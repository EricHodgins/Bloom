//
//  PhoneConnectivityManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

let NotificationLiveWorkoutStarted = "NotificationLiveWorkoutStarted"
let NofiticationNewExcerciseBegan = "NotificationNewExcerciseBegan"



class PhoneConnectivityManager: NSObject {
    
    var liveWorkoutController: LiveWorkoutController!
    
    lazy var bloomFilter: BloomFilter = {
        return BloomFilter()
    }()
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    var managedContext: NSManagedObjectContext!
    
    public init(managedContext: NSManagedObjectContext) {
        super.init()
        self.managedContext = managedContext
        setupNotifications()
    }
    
    func setupNotifications() {
        notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationLiveWorkoutStarted), object: nil, queue: nil) { (notification) in
            if let dateStarted = notification.userInfo?["StartDate"] as? NSDate,
                let name = notification.userInfo?["Name"] as? String,
                let excercises = notification.userInfo?["Excercises"] as? [String] {
                self.sendStateToWatch(date: dateStarted, name: name, excercises: excercises)
            }
        }
        
        notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NofiticationNewExcerciseBegan), object: nil, queue: nil) { (notification) in
            // send excercise values to watch
            // should update the watch state to match the phone state
        }
    }
    
    func sendStateToWatch(date: NSDate, name: String, excercises: [String]) {
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isWatchAppInstalled {
                do {
                    let dictionary: [String: Any] = ["StartDate" : date,
                                      "Name": name,
                                      "Excercises": excercises]
                    try session.updateApplicationContext(dictionary) // Application Context transfers only transfer the most recent dictionary of data over.
                } catch {
                    print("ERROR (sendStateToWatch): \(error)")
                }
            }
        }
    }
    
    func sendExcerciseStateToWatch() {
        
    }
    
    func sendWorkoutsToWatch(replyHandler: (([String : Any]) -> Void)) {
        let workouts = bloomFilter.allWorkouts(inManagedContext: managedContext)
        let workoutNames = workouts.map({ (workoutTemplate) -> String in
            return workoutTemplate.name!
        })
        replyHandler(["Workouts": workoutNames])
    }
    
    func sendExcercisesToWatch(name: String, replyHandler: (([String : Any]) -> Void)) {
        let excercises = BloomFilter.excercises(forWorkout: name, inManagedContext: managedContext)
        replyHandler(["Excercises": excercises])
    }
    
    func sendMaxReps(forExcercise: String, replyHandler: (([String : Any]) -> Void)) {
        
    }
    
    class func sendFinishedMessage() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isWatchAppInstalled {
                let message = ["Finished": true]
                do {
                    try session.updateApplicationContext(message)
                } catch {
                    print("Error sending Finish message to watch: \(error)")
                }
            }
        }
    }
    
    class func newWorkoutCreatedMessage() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isWatchAppInstalled {
                do {
                    let message = ["WorkoutDateCreated": NSDate()]
                    try session.updateApplicationContext(message)
                } catch {
                    print("Error sending workout create message to watch: \(error)")
                }
            }
        }
    }
}

extension PhoneConnectivityManager: WCSessionDelegate {
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession Did Deactivate.")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession error: \(error.localizedDescription)")
            return
        }
        
        print("WCSession activation complete. activationState: \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        if let _ = message["NeedWorkouts"] as? Bool {
            sendWorkoutsToWatch(replyHandler: replyHandler)
        }
        
        if let workoutName = message["NeedExcercises"] as? String {
            sendExcercisesToWatch(name: workoutName, replyHandler: replyHandler)
        }
        
        if let _ = message["MaxReps"] as? Bool,
            let workout = message["Workout"] as? String,
            let excercise = message["Excercise"] as? String {
            
            let bloomFilter = BloomFilter()
            let maxReps = bloomFilter.fetchMaxReps(forExcercise: excercise, inWorkout: workout, withManagedContext: managedContext)
            let replyDict: [String: String] = ["MaxReps": "\(maxReps)"]
            replyHandler(replyDict)
        }
        
        if let _ = message["MaxWeight"] as? Bool,
            let workout = message["Workout"] as? String,
            let excercise = message["Excercise"] as? String {
            
            let bloomFilter = BloomFilter()
            let maxWeight = bloomFilter.fetchMaxWeight(forExcercise: excercise, inWorkout: workout, withManagedContext: managedContext)
            let replyDict: [String: String] = ["MaxWeight": "\(maxWeight)"]
            replyHandler(replyDict)
        }
        
        //Mark: - Save Excercise Values
        if let _ = message["SaveAll"] as? Bool,
            let reps = message["Reps"] as? Double,
            let weight = message["Weight"] as? Double,
            let distance = message["Distance"] as? Double,
            let time = message["Time"] as? NSDate,
            let orderNumber = message["OrderNumber"] as? Int {
            
            replyHandler(["Done": true])
            liveWorkoutController.workoutSessionManager.save(reps: reps, weight: weight, distance: distance, time: time, orderNumber: Int16(orderNumber))
        }
        
        //MARK: - Workout has begun on watch. Transition Phone app to live workout session.
        if let workoutName = message["Name"] as? String,
            let startDate = message["StartDate"] as? NSDate {
            
            replyHandler(["PhoneActivated": true])
            
            segueToLiveWorkout(workoutName: workoutName, startDate: startDate)
        }
        
        //MARK: - Need Image Data
        if let _ = message["NeedWorkoutButtonImageData"] as? Bool,
                let height = message["Height"] as? Double,
                let width = message["Width"] as? Double {
            
            let size = CGSize(width: width, height: height)
            let bottomColor = UIColor(red: 255/255, green: 85/255, blue: 0.0, alpha: 1.0)
            let topColor = UIColor(red: 255/255, green: 112/255, blue: 189/255, alpha: 1.0)
            let imageData = UIImage.gradientImageData(size: size, topUIColor: topColor, bottomUIColor: bottomColor)
            
            replyHandler(["WorkoutButtonImageData": imageData])
        }
        
        if let _ = message["NeedStatButtonImageData"] as? Bool,
            let height = message["Height"] as? Double,
            let width = message["Width"] as? Double  {
            
            let size = CGSize(width: width, height: height)
            let bottomColor = UIColor(red: 4/255, green: 132/255, blue: 255/255, alpha: 1.0)
            let topColor = UIColor(red: 105/255, green: 219/255, blue: 255/255, alpha: 1.0)
            let imageData = UIImage.gradientImageData(size: size, topUIColor: topColor, bottomUIColor: bottomColor)
            
            replyHandler(["StatButtonImageData": imageData])
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
        
        //MARK: - Workout Finished on Watch
        if let finishDate = message["Finished"] as? NSDate {
            
            liveWorkoutController.workoutSessionManager.save(finishedDate: finishDate)
            DispatchQueue.main.async {
                self.liveWorkoutController.workoutFinishedOnWatch()
            }
        }
    }

}


//MARK: - Helper Methods
extension PhoneConnectivityManager {
    
    func segueToLiveWorkout(workoutName: String, startDate: NSDate) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        liveWorkoutController = storyboard.instantiateViewController(withIdentifier: "Live") as! LiveWorkoutController
        let workoutSessionManager = WorkoutSessionManager(managedContext: managedContext, workoutName: workoutName, startDate: startDate, deviceInitiated: .watch)
        liveWorkoutController.workoutSessionManager = workoutSessionManager
        liveWorkoutController.managedContext = managedContext
        
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let root = storyboard.instantiateViewController(withIdentifier: "Main") as! MainViewController
        root.managedContext = managedContext
        nav.viewControllers = [root]
        window?.rootViewController = nav
        
        DispatchQueue.main.async {
            window?.rootViewController?.present(self.liveWorkoutController, animated: true, completion: nil)
        }
    }
}
















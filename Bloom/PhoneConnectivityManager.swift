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
        // Coming from LiveWorkoutController when starting a new workout.
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
    
    //MARK: - Workout started on iPhone
    func sendStateToWatch(date: NSDate, name: String, excercises: [String]) {
        if WCSession.isSupported() {
            let session = WCSession.default
            if session.isWatchAppInstalled {
                let dict: [String: Any] = ["StartDate": date, "Name": name, "Excercises": excercises]
                session.sendMessage(dict, replyHandler: nil, errorHandler: { (error) in
                    print("Error sending state to watch from phone: \(error.localizedDescription)")
                })
            }
        }
    }
    
    //MARK: - Stream Heart Rate Request
    func requestToStreamHeartRate(stream: Bool) {
        if WCSession.isSupported() {
            let session = WCSession.default
            if session.isWatchAppInstalled {
                let dict: [String: Bool] = ["StreamHeartRate": stream]
                session.sendMessage(dict, replyHandler: nil, errorHandler: { (error) in
                    print("Error requesting Streaming HEart Rate from phone: \(error.localizedDescription)")
                })
            }
        }
    }
    
    //MARK: - Request Excercises
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
    
    class func sendFinishedMessage() {
        if WCSession.isSupported() {
            let session = WCSession.default
            if session.isWatchAppInstalled {
                let message = ["Finished": true]
                session.sendMessage(message, replyHandler: nil, errorHandler: { (error) in
                    print("Error sending Finish message to watch: \(error.localizedDescription)")
                })
            }
        }
    }
    
    class func newWorkoutCreatedMessage() {
        if WCSession.isSupported() {
            let session = WCSession.default
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
    
    class func goToNextExcerciseOnWatch(sets: String, reps: String, weight: String, distance: String) {
        if WCSession.isSupported() {
            let session = WCSession.default
            if session.isWatchAppInstalled {
                let message: [String: Any] = ["GoToNextExcercise": true, "Sets": sets, "Reps": reps, "Weight": weight, "Distance": distance]
                session.sendMessage(message, replyHandler: nil, errorHandler: { (error) in
                    print(error.localizedDescription)
                })
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
        
        //MARK: - Reqeusted initial excercise values
        if let _ = message["InitialExcerciseValues"] as? Bool {
            self.liveWorkoutController.rlec.provideCurrentExcerciseValuesToWatch(completion: { (sets, reps, weight, distance) in
                let dict: [String: Any] = ["Sets": sets, "Reps": reps, "Weight": weight, "Distance": distance]
                replyHandler(dict)
            })
        }
        
        // MARK: - Next Excercise Pushed on Watch
        // message["NextExcercise"] returns the excerciseIndex
        if let _ = message["NextExcercisePressed"] as? Int {
            DispatchQueue.main.async {
                self.liveWorkoutController.rlec.nextExcercise(self, completion: { (sets, reps, weight, distance) in
                    let dict: [String: Any] = ["Sets": sets, "Reps": reps, "Weight": weight, "Distance": distance]
                    replyHandler(dict)
                })
            }
        }
        
        //Mark: - Save Excercise Values
        if let _ = message["SaveAll"] as? Bool,
            let reps = message["Reps"] as? Double,
            let weight = message["Weight"] as? Double,
            let distance = message["Distance"] as? Double,
            let time = message["Time"] as? Date,
            let orderNumber = message["OrderNumber"] as? Int {
            
            replyHandler(["Done": true])
            liveWorkoutController.workoutSessionManager.save(reps: reps, weight: weight, distance: distance, time: time, orderNumber: Int16(orderNumber))
        }
        
        //MARK: - Workout has begun on watch. Transition Phone app to live workout session.
        if let workoutName = message["Name"] as? String,
            let startDate = message["StartDate"] as? Date {
            
            replyHandler(["PhoneActivated": true])
            
            segueToLiveWorkout(workoutName: workoutName, startDate: startDate)
        }
        
        //MARL: - Received Sync Message
        if let sync = message["Sync"] as? Bool {
            if sync == true {
                if liveWorkoutController != nil {
                    liveWorkoutController.sendStateToWatch()
                    replyHandler(["WorkoutStarted": true])
                } else {
                    replyHandler(["WorkoutStarted": false])
                }
            }
        }
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
        
        //MARK: - Heart Rate Streaming
        if let heartRateString = message["HeartRate"] as? String {
            liveWorkoutController.updateHeartRate(value: heartRateString)
        }
        
        //MARK: - Workout Finished on Watch
        if let finishDate = message["Finished"] as? Date {
            
            liveWorkoutController.workoutSessionManager.save(finishedDate: finishDate)
            DispatchQueue.main.async {
                self.liveWorkoutController.workoutFinishedOnWatch()
            }
        }
    }

}


//MARK: - Helper Methods
extension PhoneConnectivityManager {
    
    func segueToLiveWorkout(workoutName: String, startDate: Date) {
        
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
















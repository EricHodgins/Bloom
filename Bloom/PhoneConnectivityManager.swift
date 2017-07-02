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

class PhoneConnectivityManager: NSObject {
    
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
        sendWorkoutsToWatch()
        setupNotifications()
    }
    
    func setupNotifications() {
        notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationLiveWorkoutStarted), object: nil, queue: nil) { (notification) in
            if let dateStarted = notification.userInfo?["workoutStartDate"] as? NSDate {
                self.sendStateToWatch(date: dateStarted)
            }
        }
    }
    
    func sendStateToWatch(date: NSDate) {
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isWatchAppInstalled {
                do {
                    let dictionary = ["workoutStartDate" : date]
                    try session.updateApplicationContext(dictionary) // Application Context transfers only transfer the most recent dictionary of data over.
                } catch {
                    print("ERROR (sendStateToWatch): \(error)")
                }
            }
        }
    }
    
    func sendWorkoutsToWatch() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isWatchAppInstalled {
                let workouts = bloomFilter.allWorkouts(inManagedContext: managedContext)
                let workoutNames = workouts.map({ (workoutTemplate) -> String in
                    return workoutTemplate.name!
                })
                session.sendMessage(["Workouts": workoutNames], replyHandler: nil, errorHandler: nil)
            }
        }
    }
    
    func sendExcercisesToWatch(name: String, replyHandler: (([String : Any]) -> Void)) {
        let excercises = BloomFilter.excercises(forWorkout: name, inManagedContext: managedContext)
        replyHandler(["Excercises": excercises])
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
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {

    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let _ = message["NeedWorkouts"] {
            sendWorkoutsToWatch()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let workoutName = message["NeedExcercises"] as? String {
            sendExcercisesToWatch(name: workoutName, replyHandler: replyHandler)
        }
    }
    
}

















//
//  WatchConnectivityManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import WatchConnectivity

let NotificationRequestWorkouts = "NotificationRequestWorkouts"

class WatchConnectivityManager: NSObject {
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    override init() {
        super.init()
        setupNotifications()
    }
    
    func setupNotifications() {
        notificationCenter.addObserver(self, selector: #selector(WatchConnectivityManager.requestWorkouts), name: NSNotification.Name(rawValue: NotificationRequestWorkouts), object: nil)
    }
    
    func requestWorkouts() {
        let session = WCSession.default()
        if WCSession.isSupported() {
            if session.isReachable {
                session.sendMessage(["NeedWorkouts": true], replyHandler: nil, errorHandler: nil)
            }
        }
    }
    
    class func requestExcercises(forWorkout workout: String) {
        let session = WCSession.default()
        if WCSession.isSupported() {
            if session.isReachable {
                session.sendMessage(["NeedExcercises": workout], replyHandler: { (reply) in
                    print(reply)
                    if let excercises = reply["Excercises"] as? [String] {
                        WorkoutManager.shared.currentExcercises = excercises
                    }
                }, errorHandler: nil)
            }
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession error: \(error.localizedDescription)")
            return
        }
        
        print("WCSession activation complete. activationState: \(activationState.rawValue)")
        requestWorkouts()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let timeStartedOnPhone = applicationContext["StartDate"] as? NSDate,
            let workoutName = applicationContext["Name"] as? String,
            let excercises = applicationContext["Excercises"] as? [String] {
            
            WorkoutManager.shared.currentWorkout = workoutName
            WorkoutManager.shared.currentExcercises = excercises
            
            DispatchQueue.main.async(execute: {
                let contexts = [["workoutStartDate" : timeStartedOnPhone]]
                WKInterfaceController.reloadRootControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: contexts)
            })
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let workouts = message["Workouts"] as? [String] {
            print(workouts)
            for workoutName in workouts {
                WorkoutManager.shared.workouts.append(workoutName)
            }
        }
    }
}

























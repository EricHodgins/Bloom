//
//  WatchConnectivityManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import WatchConnectivity

let NotificationWorkoutStartedOnWatch = "NotificationWorkoutStartedOnWatch"

class WatchConnectivityManager: NSObject {
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    override init() {
        super.init()
        setupNotifications()
    }
    
    func setupNotifications() {
        notificationCenter.addObserver(self, selector: #selector(WatchConnectivityManager.sendStateToPhone), name: NSNotification.Name(rawValue: NotificationWorkoutStartedOnWatch), object: nil)
    }
    
    func requestWorkouts() {
        let session = WCSession.default()
        if WCSession.isSupported() {
            if session.isReachable {
                session.sendMessage(["NeedWorkouts": true], replyHandler: nil, errorHandler: { (error) in
                    print("Request Workouts Error: \(error)")
                    self.requestWorkouts()
                })
            }
        }
    }
    
    class func requestExcercises(forWorkout workout: String, completion: @escaping (([String]) -> Void)) {
        let session = WCSession.default()
        if WCSession.isSupported() {
            if session.isReachable {
                session.sendMessage(["NeedExcercises": workout], replyHandler: { (reply) in
                    print(reply)
                    if let excercises = reply["Excercises"] as? [String] {
                        completion(excercises)
                    }
                }, errorHandler: nil)
            }
        }
    }
    
    class func requestMaxReps(forExcercise excercise: String, inWorkout workout: String, completion: @escaping ((Double) -> Void)) {
        let session = WCSession.default()
        if WCSession.isSupported() {
            if session.isReachable {
                session.sendMessage(["MaxReps": true, "Excercise": excercise, "Workout": workout], replyHandler: { (maxRepsDict) in
                    print("Received max reps dict")
                    if let repsString = maxRepsDict["MaxReps"] as? String {
                        let reps = Double(repsString)!
                        completion(reps)
                    }
                }, errorHandler: { (error) in
                    print("Error receving reply from phone for maxReps dict: \(error)")
                })
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
        // This should be executed when Phone initiates a workout and watch app is not in a live workout routine
        if let timeStartedOnPhone = applicationContext["StartDate"] as? NSDate,
            let workoutName = applicationContext["Name"] as? String,
            let excercises = applicationContext["Excercises"] as? [String] {
            
            WorkoutManager.shared.currentWorkout = workoutName
            WorkoutManager.shared.currentExcercises = excercises
            WorkoutManager.shared.workoutStartDate = timeStartedOnPhone
            
            DispatchQueue.main.async(execute: {
                let contexts = [["workoutStartDate" : timeStartedOnPhone]]
                WKInterfaceController.reloadRootControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: contexts)
            })
        }
    }
    
    func sendStateToPhone() {
        if WCSession.isSupported() {
        let session = WCSession.default()
            do {
                let dictionary: [String: Any] = ["StartDate" : WorkoutManager.shared.workoutStartDate!,
                                                 "Name": WorkoutManager.shared.currentWorkout!
                                                 ]
                try session.updateApplicationContext(dictionary) // Application Context transfers only transfer the most recent dictionary of data over.
            } catch {
                print("ERROR (sendStateToWatch): \(error)")
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // This populates the workout table; displaying their names
        if let workouts = message["Workouts"] as? [String] {
            print(workouts)
            for workoutName in workouts {
                WorkoutManager.shared.workouts.append(workoutName)
            }
        }
    }
}

























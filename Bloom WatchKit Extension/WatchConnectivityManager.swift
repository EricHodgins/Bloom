//
//  WatchConnectivityManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import WatchConnectivity

let NotificationWatchConnectivityActive = "NotificationWatchConnectivityActive"
let NotificationWorkoutsReceived = "NotificationWorkoutsReceived"

enum ActicationState: String {
    case active
    case inactive
}

class WatchConnectivityManager: NSObject {
    
    static let shared = WatchConnectivityManager()
    var state: ActicationState = .inactive
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    private override init() {
        super.init()
    }
    
    class func requestWorkouts(completion: @escaping ([String]) -> Void) {
        let session = WCSession.default()
        if WCSession.isSupported() {
            if session.isReachable {
                session.sendMessage(["NeedWorkouts": true], replyHandler: { workouts in
                    guard let workoutNames = workouts["Workouts"] as? [String] else { return }
                    print("Reply Handler: \(workoutNames)")
                    completion(workoutNames)
                }, errorHandler: { (error) in
                    print("Error requesting all workout routines: \(error)")
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
    
    class func save(reps: String, orderNumber: String) {
        let session = WCSession.default()
        if WCSession.isSupported() {
            if session.isReachable {
                let saveDict = ["Reps": reps, "OrderNumber": orderNumber]
                session.sendMessage(saveDict, replyHandler: nil, errorHandler: { (error) in
                    print("Could not send message to save: \(error)")
                })
            }
        }
    }
    
    class func sendWorkoutStartMessageToPhone() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isReachable {
                let dict: [String : Any] = ["Name": WorkoutManager.shared.currentWorkout!, "StartDate": WorkoutManager.shared.workoutStartDate!]
                session.sendMessage(dict, replyHandler: nil, errorHandler: nil)
            }
        }
    }
    
    class func sendWorkoutFinishedMessageToPhone() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isReachable {
                let dict: [String : Bool] = ["Finished" : true]
                session.sendMessage(dict, replyHandler: nil, errorHandler: { (error) in
                    print("Message error workout finished: \(error)")
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
        state = .active
        notificationCenter.post(name: NSNotification.Name(rawValue: NotificationWatchConnectivityActive), object: nil)
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
        if let _ = message["Finished"] as? Bool {
            DispatchQueue.main.async {
                WKInterfaceController.reloadRootControllers(withNames: ["Main"], contexts: nil)
            }
        }
    }
}

























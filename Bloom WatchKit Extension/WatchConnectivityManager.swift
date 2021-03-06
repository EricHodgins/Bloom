//
//  WatchConnectivityManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import WatchConnectivity
import HealthKit

let NotificationWatchConnectivityActive = "NotificationWatchConnectivityActive"
let NotificationWorkoutsReceived = "NotificationWorkoutsReceived"
let NotificationWorkoutHasFinishedOnPhone = "NotificationWorkoutHasFinishedOnPhone"

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
    
    //MARK: - Request Workouts
    class func requestWorkouts(completion: @escaping ([String]) -> Void) {
        let session = WCSession.default
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
    
    //MARK: - Request Excercises
    class func requestExcercises(forWorkout workout: String, completion: @escaping (([String]) -> Void)) {
        let session = WCSession.default
        if WCSession.isSupported() {
            if session.isReachable {
                print("Requesting excercises....")
                session.sendMessage(["NeedExcercises": workout], replyHandler: { (reply) in
                    print("Received message for excercises: \(reply)")
                    if let excercises = reply["Excercises"] as? [String] {
                        completion(excercises)
                    }
                }, errorHandler: nil)
            }
        }
    }
    
    //MARK: - Request Max Reps
    class func requestMaxReps(forExcercise excercise: String, inWorkout workout: String, completion: @escaping ((Double) -> Void)) {
        let session = WCSession.default
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
    
    //MARK: - Request Max Weight
    class func requestMaxWeight(forExcercise excercise: String, inWorkout workout: String, completion: @escaping ((Double) -> Void)) {
        let session = WCSession.default
        if WCSession.isSupported() {
            if session.isReachable {
                session.sendMessage(["MaxWeight" : true, "Excercise": excercise, "Workout": workout], replyHandler: { (maxWeightDict) in
                    if let weightString = maxWeightDict["MaxWeight"] as? String {
                        let weight = Double(weightString)!
                        completion(weight)
                    }
                }, errorHandler: { (error) in
                    print("Error receiving reply from phone for max weight: \(error)")
                })
            }
        }
    }
    
    //MARK: - Request Initial Excercise Values
    class func initialExcerciseValues(completion: @escaping (() -> Void)) {
        let session = WCSession.default
        if WCSession.isSupported() {
            if session.isReachable {
                let dict: [String: Bool] = ["InitialExcerciseValues": true]
                session.sendMessage(dict, replyHandler: { (reply) in
                    if let sets = reply["Sets"] as? String,
                        let reps = reply["Reps"] as? String,
                        let weight = reply["Weight"] as? String,
                        let distance = reply["Distance"] as? String {
                        WorkoutManager.shared.activeExcercise.sets = sets
                        WorkoutManager.shared.activeExcercise.reps = reps
                        WorkoutManager.shared.activeExcercise.weight = weight
                        WorkoutManager.shared.activeExcercise.distance = distance
                        completion()
                    }
                }, errorHandler: { (error) in
                    print(error.localizedDescription)
                })
            }
        }
    }
    
    //MARK: - Next Excercise Pressed on Watch
    class func nextExcercise(excerciseIndex: Int, completion:@escaping (() -> Void)) {
        let session = WCSession.default
        if WCSession.isSupported() {
            if session.isReachable {
                let dict: [String: Int] = ["NextExcercisePressed": excerciseIndex]
                session.sendMessage(dict, replyHandler: { (reply) in
                    if let sets = reply["Sets"] as? String,
                       let reps = reply["Reps"] as? String,
                       let weight = reply["Weight"] as? String,
                       let distance = reply["Distance"] as? String {

                        WorkoutManager.shared.activeExcercise.sets = sets
                        WorkoutManager.shared.activeExcercise.reps = reps
                        WorkoutManager.shared.activeExcercise.weight = weight
                        WorkoutManager.shared.activeExcercise.distance = distance
                        completion()
                    }
                }
                    , errorHandler: { (error) in
                        print("Error on Next Excercise Press: \(error.localizedDescription)")
                })
            }
        }
    }
    
    //Mark: - Save All Values for Excercise
    class func save(reps: Double, weight: Double, distance: Double, time: NSDate, orderNumber: Int) {
        let session = WCSession.default
        if WCSession.isSupported() {
            if session.isReachable {
                let saveDict: [String: Any] = ["SaveAll": true,
                                               "Reps": reps,
                                               "Weight": weight,
                                               "Distance": distance,
                                               "Time": time,
                                               "OrderNumber": orderNumber]
                session.sendMessage(saveDict, replyHandler: { (reply) in
                    print("Reply handler received from phone...awesome: \(reply["Done"]!)")
                }, errorHandler: { (error) in
                    print("Could not send save dict for all values: \(error)")
                })
            }
        }
    }
    
    //MARK: - Send Workout Started Message
    class func sendWorkoutStartMessageToPhone() {
        if WCSession.isSupported() {
            let session = WCSession.default
            if session.isReachable {
                let dict: [String : Any] = ["Name": WorkoutManager.shared.currentWorkout!, "StartDate": WorkoutManager.shared.workoutStartDate!]
                session.sendMessage(dict, replyHandler: { (reply) in
                    print("Phone was activated: \(reply["PhoneActivated"]!)")
                }, errorHandler: { (error) in
                    print("Error activating phone when workout started: \(error)")
                })
                session.sendMessage(dict, replyHandler: nil, errorHandler: nil)
            }
        }
    }
    
    //MARK: - Send Workout Finished Message
    class func sendWorkoutFinishedMessageToPhone(date: NSDate) {
        if WCSession.isSupported() {
            let session = WCSession.default
            if session.isReachable {
                let dict: [String : NSDate] = ["Finished" : date]
                session.sendMessage(dict, replyHandler: nil, errorHandler: { (error) in
                    print("Message error workout finished: \(error)")
                })
            }
        }
    }
    
    //MARK: - Stream Heart Rate
    class func sendHeartRateToPhone(heartRateString: String) {
        if WCSession.isSupported() {
            let session = WCSession.default
            if session.isReachable {
                let dict: [String: String] = ["HeartRate" : heartRateString]
                session.sendMessage(dict, replyHandler: nil, errorHandler: { (error) in
                    print("Error streaming Heart Rate sample from watch: \(error.localizedDescription)")
                })
            }
        }
    }
    
    //MARK: - Sync Workout (workout started on Phone)
    class func requestSyncWithPhone(completion: @escaping ((Bool) -> Void)) {
        if WCSession.isSupported() {
            let session = WCSession.default
            if session.isReachable {
                let dict: [String: Bool] = ["Sync": true]
                session.sendMessage(dict, replyHandler: { (reply) in
                    let message = reply["WorkoutStarted"] as! Bool
                    if message == false {
                        //Notify user workout has not started on phone.
                        completion(message)
                    }
                }, errorHandler: { (error) in
                   print("Error syncing phone to watch: \(error.localizedDescription)")
                })
            }
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    
    //MARK: - Activation Complete
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession error: \(error.localizedDescription)")
            return
        }
        
        print("WCSession activation complete. activationState: \(activationState.rawValue)")
        state = .active
        notificationCenter.post(name: NSNotification.Name(rawValue: NotificationWatchConnectivityActive), object: nil)
    }
    
    //MARK: - Received Application Context
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        // New Workout Created on the Phone
        if let _ = applicationContext["WorkoutDateCreated"] as? NSDate {
            notificationCenter.post(name: NSNotification.Name(rawValue: NotificationWatchConnectivityActive), object: nil)
        }
    }
    
    //MARK: - Received Message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let isStreamingHeartRate = message["StreamHeartRate"] as? Bool {
            if isStreamingHeartRate == true {
                WorkoutManager.shared.isStreamingHeartRateDataToPhone = true
            } else {
                WorkoutManager.shared.isStreamingHeartRateDataToPhone = false
            }
        }
        
        if let _ = message["GoToNextExcercise"] as? Bool,
            let sets = message["Sets"] as? String,
            let reps = message["Reps"] as? String,
            let weight = message["Weight"] as? String,
            let distance = message["Distance"] as? String {
            
            WorkoutManager.shared.activeExcercise.sets = sets
            WorkoutManager.shared.activeExcercise.reps = reps
            WorkoutManager.shared.activeExcercise.weight = weight
            WorkoutManager.shared.activeExcercise.distance = distance
            WorkoutManager.shared.udpateExcerciseValues()
        }
        
        // New Workout has been initiated
        setupWatchInterfaceForWorkout(message: message)
        
        // Finish workout.  Hit Finish button on phone
        if let _ = message["Finished"] as? Bool {
            //1. Notify to stop workout session
            notificationCenter.post(name: NSNotification.Name(rawValue: NotificationWorkoutHasFinishedOnPhone), object: nil)
            //2.
            DispatchQueue.main.async {
                WKInterfaceController.reloadRootPageControllers(withNames: ["Main"], contexts: nil, orientation: .horizontal, pageIndex: 0)
            }
        }
    }
    
    // Workout Has Begun (Start was pressed on iPhone)
    func setupWatchInterfaceForWorkout(message: [String: Any]) {
        // This should be executed when Phone initiates a workout and watch app is not in a live workout routine
        if let timeStartedOnPhone = message["StartDate"] as? NSDate,
            let workoutName = message["Name"] as? String,
            let excercises = message["Excercises"] as? [String] {
            
            WorkoutManager.shared.currentWorkout = workoutName
            WorkoutManager.shared.currentExcercises = excercises
            WorkoutManager.shared.workoutStartDate = timeStartedOnPhone
            
            let workoutSessionService = setupWorkouSessionService()
            
            DispatchQueue.main.async(execute: {
                let contexts: [Any]
                guard let workoutSessionService = workoutSessionService else {
                    contexts = [["workoutStartDate" : timeStartedOnPhone]]
                    WKInterfaceController.reloadRootPageControllers(withNames: ["LiveWorkout", "RepsWeight", "Finish"], contexts: contexts, orientation: .horizontal, pageIndex: 0)
                    return
                }
                workoutSessionService.startSession()
                contexts = [["WorkoutSessionService": workoutSessionService, "workoutStartDate" : timeStartedOnPhone], workoutSessionService, workoutSessionService, workoutSessionService]
                
                WKInterfaceController.reloadRootPageControllers(withNames: ["LiveWorkout", "RepsWeight", "Finish"], contexts: contexts, orientation: .horizontal, pageIndex: 0)
            })
        }
    }
}


//MARK: - Helper Methods
extension WatchConnectivityManager {
    //MARK: - Send State to Phone
    func sendStateToPhone() {
        if WCSession.isSupported() {
            let session = WCSession.default
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
    
    func setupWorkouSessionService() -> WorkoutSessionService? {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        workoutConfiguration.locationType = .outdoor
        
        let workoutSessionService = WorkoutSessionService(configuration: workoutConfiguration)
        let workoutAuthorizedStatus = workoutSessionService?.workoutAuthorizationStatus()
        let heartRateAuthorizedStatus = workoutSessionService?.heartRateAuthorizationStatus()
        
        if workoutAuthorizedStatus == .sharingAuthorized && heartRateAuthorizedStatus == .sharingAuthorized && workoutSessionService != nil {
            return workoutSessionService
        }
        
        return nil
    }
}






















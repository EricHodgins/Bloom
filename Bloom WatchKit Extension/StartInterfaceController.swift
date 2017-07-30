//
//  StartInterfaceController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class StartInterfaceController: WKInterfaceController {

    @IBOutlet var workoutName: WKInterfaceLabel!
    @IBOutlet var startButton: WKInterfaceButton!
    
    var workoutSessionService: WorkoutSessionService?
    
    lazy var configuration: HKWorkoutConfiguration = {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        workoutConfiguration.locationType = .outdoor
        return workoutConfiguration
    }()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        WorkoutManager.shared.liveWorkoutDelegate = self
        if WorkoutManager.shared.currentExcercises.count == 0 {
            startButton.setEnabled(false)
            startButton.setTitle("Loading...")
        }
        
        if let workout = context as? String {
            workoutName.setText(workout)
            WorkoutManager.shared.currentWorkout = workout
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func startButtonPressed() {
        WorkoutManager.shared.workoutStartDate = NSDate()
        WatchConnectivityManager.sendWorkoutStartMessageToPhone()
        
        workoutSessionService = WorkoutSessionService(configuration: configuration)
        
        // If workoutsession is nil
        guard let workoutSessionService = workoutSessionService else {
            WKInterfaceController.reloadRootControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: nil)
            return
        }
        
        // If workouts or Heart Rate data is not authorized by user
        let workoutAuthorizedStatus = workoutSessionService.workoutAuthorizationStatus()
        let heartRateAuthorizedStatus = workoutSessionService.heartRateAuthorizationStatus()
        
        guard workoutAuthorizedStatus == .sharingAuthorized && heartRateAuthorizedStatus == .sharingAuthorized else {
            WKInterfaceController.reloadRootControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: nil)
            return
        }
        
        // Everything is Authorized start a workout session to record a workout and heart rate data to HealthKit Store
        workoutSessionService.startSession()
        let contexts: [Any] = [["WorkoutSessionService": workoutSessionService], workoutSessionService, workoutSessionService, workoutSessionService]
        WKInterfaceController.reloadRootControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: contexts)
    }
}

extension StartInterfaceController: LiveWorkoutDelegate {
    func updateExcercises() {
        print("Excercises set...")
        if WorkoutManager.shared.currentExcercises.count > 0 {
            startButton.setTitle("Start")
            startButton.setEnabled(true)
        }
    }
}

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
        if WorkoutManager.shared.currentExcercises.count == 0 {
            startButton.setEnabled(false)
            startButton.setTitle("Loading...")
        }
        
        if let workout = context as? String {
            workoutName.setText(workout)
            WorkoutManager.shared.currentWorkout = workout
        }
    }

    @IBAction func startButtonPressed() {
        WorkoutManager.shared.workoutStartDate = NSDate()
        WatchConnectivityManager.sendWorkoutStartMessageToPhone()
        
        workoutSessionService = WorkoutSessionService(configuration: configuration)
        
        // If workoutsession is nil
        guard let workoutSessionService = workoutSessionService else {
            WKInterfaceController.reloadRootPageControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: nil, orientation: .horizontal, pageIndex: 0)
            return
        }
        
        // If workouts or Heart Rate data is not authorized by user
        let workoutAuthorizedStatus = workoutSessionService.workoutAuthorizationStatus()
        let heartRateAuthorizedStatus = workoutSessionService.heartRateAuthorizationStatus()
        
        guard workoutAuthorizedStatus == .sharingAuthorized && heartRateAuthorizedStatus == .sharingAuthorized else {
            WKInterfaceController.reloadRootPageControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: nil, orientation: .horizontal, pageIndex: 0)
            return
        }
        
        // Everything is Authorized start a workout session to record a workout and heart rate data to HealthKit Store
        workoutSessionService.startSession()
        let contexts: [Any] = [["WorkoutSessionService": workoutSessionService], workoutSessionService, workoutSessionService, workoutSessionService]
        WKInterfaceController.reloadRootPageControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: contexts, orientation: .horizontal, pageIndex: 0)
    }
}


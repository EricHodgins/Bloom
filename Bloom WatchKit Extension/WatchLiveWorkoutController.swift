//
//  WatchLiveWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-25.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import Foundation


class WatchLiveWorkoutController: WKInterfaceController {

    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var excerciseLabel: WKInterfaceLabel!
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    var workoutSessionService: WorkoutSessionService?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        excerciseLabel.setText(WorkoutManager.shared.currentWorkout!)
        
        // Check for WorkoutServiceSession for HeartRate data and Workout for HealthKit Store
        if let contextDict = context as? [String: Any],
            let workoutSessionService = contextDict["WorkoutSessionService"] as? WorkoutSessionService {
            self.workoutSessionService = workoutSessionService
            self.workoutSessionService?.delegate = self
        }
        
        // Check if initiated by phone
        guard let contextDict = context as? [String : Any],
            let timeStarted = contextDict["workoutStartDate"] as? NSDate else {
                if WorkoutManager.shared.currentExcercises.count > 0 {
                    excerciseLabel.setText(WorkoutManager.shared.currentExcercises[0])
                } else {
                    excerciseLabel.setText("Loading Data...")
                }
                timer.start()
            return
        }
        
        WorkoutManager.shared.workoutStartDate = timeStarted
        let diff = Date.timeIntervalSinceReferenceDate - timeStarted.timeIntervalSinceReferenceDate
        timer.setDate(Date(timeIntervalSinceNow: -diff))
        timer.start()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func nextExcerciseButtonPressed() {
        WorkoutManager.shared.timeRecorded = NSDate()
        WorkoutManager.shared.save()
        excerciseLabel.setText(WorkoutManager.shared.nextExcercise())
        WorkoutManager.shared.updateMaxReps()
        WorkoutManager.shared.updateMaxWeight()
    }
}


extension WatchLiveWorkoutController: WorkoutSessionServiceDelegate {
    func workoutSessionService(didUpdateHeartRate heartRate: Double) {
        DispatchQueue.main.async {
            self.heartRateLabel.setText("\(heartRate) BPM")
        }
    }
}







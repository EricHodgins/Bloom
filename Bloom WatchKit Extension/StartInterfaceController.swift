//
//  StartInterfaceController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import Foundation


class StartInterfaceController: WKInterfaceController {

    @IBOutlet var workoutName: WKInterfaceLabel!
    @IBOutlet var startButton: WKInterfaceButton!
    
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
        WKInterfaceController.reloadRootControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: nil)
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

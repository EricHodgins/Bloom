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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
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
        WKInterfaceController.reloadRootControllers(withNames: ["LiveWorkout", "RepsWeight", "DistanceTime", "Finish"], contexts: nil)
    }
}

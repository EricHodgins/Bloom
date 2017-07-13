//
//  RepsWeightController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-05.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import Foundation


class RepsWeightController: WKInterfaceController {

    @IBOutlet var repsLabel: WKInterfaceLabel!
    @IBOutlet var weightLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let reps = WorkoutManager.shared.reps {
            repsLabel.setText("Reps: \(reps)")
        } else {
            repsLabel.setText("Reps: 10")
        }
        
        if let weight = WorkoutManager.shared.weight {
            weightLabel.setText("Weight: \(weight) lbs")
        } else {
            weightLabel.setText("Weight: 10 lbs")
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
    
    @IBAction func repsIncreasePressed() {
        guard let reps = WorkoutManager.shared.reps else {
            WorkoutManager.shared.reps = 10
            repsLabel.setText("Reps: 10)")
            return
        }
        WorkoutManager.shared.reps = reps + 1.0
        repsLabel.setText("Reps: \(WorkoutManager.shared.reps!)")
    }
    
    @IBAction func repsDecreasePressed() {
        guard let reps = WorkoutManager.shared.reps else {
            WorkoutManager.shared.reps = 10
            repsLabel.setText("Reps: 10)")
            return
        }
        WorkoutManager.shared.reps = reps - 1.0
        repsLabel.setText("Reps: \(WorkoutManager.shared.reps!)")
    }
    
    @IBAction func weightIncreasedPressed() {
        guard let weight = WorkoutManager.shared.weight else {
            WorkoutManager.shared.weight = 10
            weightLabel.setText("Weight: 10 lbs")
            return
        }
        
        WorkoutManager.shared.weight = weight + 1.0
        weightLabel.setText("Weight: \(WorkoutManager.shared.weight!) lbs")
    }
    
    @IBAction func weightDecreasedPressed() {
        guard let weight = WorkoutManager.shared.weight else {
            WorkoutManager.shared.weight = 10
            weightLabel.setText("Weight: 10 lbs")
            return
        }
        
        WorkoutManager.shared.weight = weight - 1.0
        weightLabel.setText("Weight: \(WorkoutManager.shared.weight!) lbs")
    }
    
    
}























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
        
        WorkoutManager.shared.repsWeightDelegate = self
        
        updateReps()
        
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
            return
        }
        WorkoutManager.shared.reps = reps + 1.0
    }
    
    @IBAction func repsDecreasePressed() {
        guard let reps = WorkoutManager.shared.reps else {
            WorkoutManager.shared.reps = 10
            return
        }
        WorkoutManager.shared.reps = reps - 1.0
    }
    
    @IBAction func weightIncreasedPressed() {
        guard let weight = WorkoutManager.shared.weight else {
            WorkoutManager.shared.weight = 10
            return
        }
        
        WorkoutManager.shared.weight = weight + 1.0
    }
    
    @IBAction func weightDecreasedPressed() {
        guard let weight = WorkoutManager.shared.weight else {
            WorkoutManager.shared.weight = 10
            return
        }
        
        WorkoutManager.shared.weight = weight - 1.0
    }
    
    
}

extension RepsWeightController: RepsWeightDelegate {
    func updateReps() {
        guard let reps = WorkoutManager.shared.reps else { return }
        repsLabel.setText("Reps: \(reps)")
    }
    
    func updateWeight() {
        guard let weight = WorkoutManager.shared.weight else { return }
        weightLabel.setText("Weight: \(weight) lbs")
    }
}





















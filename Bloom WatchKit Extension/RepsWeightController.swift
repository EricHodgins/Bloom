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

    @IBOutlet var setsLabel: WKInterfaceLabel!
    @IBOutlet var repsLabel: WKInterfaceLabel!
    @IBOutlet var weightLabel: WKInterfaceLabel!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        WorkoutManager.shared.repsWeightDelegate = self
    }
    
}

extension RepsWeightController: RepsWeightDelegate {
    func updateExcerciseValues() {
        DispatchQueue.main.async {
            self.setsLabel.setText("Sets: \(WorkoutManager.shared.activeExcercise.sets)")
            self.repsLabel.setText("Reps: \(WorkoutManager.shared.activeExcercise.reps)")
            self.weightLabel.setText("Weight: \(WorkoutManager.shared.activeExcercise.weight)")
            self.distanceLabel.setText("Distance: \(WorkoutManager.shared.activeExcercise.distance)")
        }
    }
}





















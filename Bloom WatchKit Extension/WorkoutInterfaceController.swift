//
//  WorkoutInterfaceController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-26.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import Foundation


class WorkoutInterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        table.setNumberOfRows(WorkoutManager.shared.workouts.count, withRowType: "WorkoutRowType")
        
        for (index, name) in WorkoutManager.shared.workouts.enumerated() {
            let controller = table.rowController(at: index) as! WorkoutRowController
            controller.titleLabel.setText(name)
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
    
}

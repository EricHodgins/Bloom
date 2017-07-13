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
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        WorkoutManager.shared.workoutTableDelegate = self
        refresh()
    }
    
    func setupNotification() {
        notificationCenter.addObserver(self, selector: #selector(WorkoutInterfaceController.refresh), name: NSNotification.Name(rawValue: NotificationWorkoutsReceived), object: nil)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return WorkoutManager.shared.workouts[rowIndex]
    }
}


extension WorkoutInterfaceController: UpdateWorkoutsTableDelgate {
    func refreshTable() {
        refresh()
    }
    
    func refresh() {
        table.setNumberOfRows(WorkoutManager.shared.workouts.count, withRowType: "WorkoutRowType")
        
        for (index, name) in WorkoutManager.shared.workouts.enumerated() {
            let controller = table.rowController(at: index) as! WorkoutRowController
            controller.titleLabel.setText(name)
        }
        print("refreshed.")
    }
}





















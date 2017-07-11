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

    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var excerciseLabel: WKInterfaceLabel!
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let contextDict = context as? [String : NSDate],
            let timeStarted = contextDict["workoutStartDate"] else {
                excerciseLabel.setText(WorkoutManager.shared.currentExcercises[0])
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
        WorkoutManager.shared.save()
        excerciseLabel.setText(WorkoutManager.shared.nextExcercise())
        WorkoutManager.shared.updateMaxReps()
    }
    

}

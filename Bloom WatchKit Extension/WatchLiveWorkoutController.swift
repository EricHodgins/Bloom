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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let contextDict = context as? [String : NSDate],
            let timeStarted = contextDict["workoutStartDate"] else {
                timer.start()
            return
        }
        
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

}

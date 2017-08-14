//
//  FinishInterfaceController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import Foundation


class FinishInterfaceController: WKInterfaceController {
    
    var workoutSessionService: WorkoutSessionService?
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setupNotification()
        
        if let workoutSessionService = context as? WorkoutSessionService {
            self.workoutSessionService = workoutSessionService
        }
    }
    
    func setupNotification() {
        notificationCenter.addObserver(self, selector: #selector(FinishInterfaceController.finishedOnPhone), name: NSNotification.Name(rawValue: NotificationWorkoutHasFinishedOnPhone), object: nil)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func finishPressed() {
        let finishDate = NSDate()
        WorkoutManager.shared.workoutEndDate = finishDate
        if workoutSessionService != nil {
            workoutSessionService?.stopSession()
            workoutSessionService?.save()
        }
        
        WatchConnectivityManager.sendWorkoutFinishedMessageToPhone(date: finishDate)
        WorkoutManager.shared.reset()
        WKInterfaceController.reloadRootControllers(withNames: ["Main"], contexts: nil)
    }
    
    func finishedOnPhone() {
        let finishDate = NSDate()
        WorkoutManager.shared.workoutEndDate = finishDate
        if workoutSessionService != nil {
            workoutSessionService?.stopSession()
            workoutSessionService?.save()
        }
        
        WorkoutManager.shared.reset()
        WKInterfaceController.reloadRootControllers(withNames: ["Main"], contexts: nil)
    }
}

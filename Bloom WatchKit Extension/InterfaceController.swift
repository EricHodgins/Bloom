//
//  InterfaceController.swift
//  Bloom WatchKit Extension
//
//  Created by Eric Hodgins on 2016-12-12.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if WatchConnectivityManager.shared.state == .inactive {
            setupNotications()
        } else {
            requestWorkoutRoutines()
        }
    }

    func setupNotications() {
        notificationCenter.addObserver(self, selector: #selector(InterfaceController.requestWorkoutRoutines), name: NSNotification.Name(rawValue: NotificationWatchConnectivityActive), object: nil)
    }
    
    func requestWorkoutRoutines() {
        WatchConnectivityManager.requestWorkouts() { workoutNames in
            print("WOrkout request complete: \(workoutNames)")
            WorkoutManager.shared.workouts = workoutNames
            self.notificationCenter.post(name: NSNotification.Name(rawValue: NotificationWorkoutsReceived), object: nil)
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

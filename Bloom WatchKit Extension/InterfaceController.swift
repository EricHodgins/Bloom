//
//  InterfaceController.swift
//  Bloom WatchKit Extension
//
//  Created by Eric Hodgins on 2016-12-12.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import WatchKit
import UIKit
import CoreData


class InterfaceController: WKInterfaceController {
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
//    @IBOutlet var workoutsButton: WKInterfaceButton!
//    @IBOutlet var statsButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        let workoutButtonImageData = UserDefaults.standard.object(forKey: "WorkoutButtonImageData")
//        let statButtonImagedData = UserDefaults.standard.object(forKey: "StatButtonImageData")
//
//        if let workoutImgData = workoutButtonImageData as? Data,
//            let statImgData = statButtonImagedData as? Data {
//            let workoutBackgroundImage = UIImage(data: workoutImgData)!
//            let statBackgroundImage = UIImage(data: statImgData)!
//            workoutsButton.setBackgroundImage(workoutBackgroundImage)
//            statsButton.setBackgroundImage(statBackgroundImage)
//        } else {
//            notificationCenter.addObserver(self, selector: #selector(InterfaceController.setupGradientImage), name: NSNotification.Name(rawValue: NotificationWatchConnectivityActive), object: nil)
//        }
        
        if WatchConnectivityManager.shared.state == .inactive {
            notificationCenter.addObserver(self, selector: #selector(InterfaceController.requestWorkoutRoutines), name: NSNotification.Name(rawValue: NotificationWatchConnectivityActive), object: nil)
        } else {
            requestWorkoutRoutines()
        }
        
        authorizeHealthkitAccess()
    }
    
    func authorizeHealthkitAccess() {
        let healthService: HealthDataService = HealthDataService()
        
        healthService.authorizeHealthKitAccess { (success, error) in
            if success {
                print("HealthKit authorization received.")
            } else {
                print("HealthKit authorization denied! \(error ?? "No Description" as! Error)")
                if error != nil {
                    print("\(error?.localizedDescription ?? "No error description.")")
                }
            }
        }
    }
    
//    @objc func setupGradientImage() {
//        let height = Double(WKInterfaceDevice.current().screenBounds.height / 2)
//        let width = Double(WKInterfaceDevice.current().screenBounds.width)
//        WatchConnectivityManager.requestWorkoutImageData(height: height, width: width) { (imageData) in
//            print("Received image Data: \(imageData)")
//            let image = UIImage(data: imageData)!
//            UserDefaults.standard.set(imageData, forKey: "WorkoutButtonImageData")
//            DispatchQueue.main.async {
//                self.workoutsButton.setBackgroundImage(image)
//            }
//        }
//
//        WatchConnectivityManager.requestStatImageData(height: height, width: width) { (imageData) in
//            print("Received stat image data: \(imageData)")
//            let image = UIImage(data: imageData)!
//            UserDefaults.standard.set(imageData, forKey: "StatButtonImageData")
//            DispatchQueue.main.async {
//                self.statsButton.setBackgroundImage(image)
//            }
//        }
//    }
    
    @objc func requestWorkoutRoutines() {
//        WatchConnectivityManager.requestWorkouts() { workoutNames in
//            print("WOrkout request complete: \(workoutNames)")
//            WorkoutManager.shared.workouts = workoutNames
//            self.notificationCenter.post(name: NSNotification.Name(rawValue: NotificationWorkoutsReceived), object: nil)
//        }
    }
    
}

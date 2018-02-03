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
    
    @IBOutlet var syncButton: WKInterfaceButton!
    
    @IBOutlet var instructionLabel: WKInterfaceLabel!
    enum ScreenStatus {
        case isReady
        case syncFailed
    }
    
    var userStatus: ScreenStatus = .isReady
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
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
    
    @IBAction func syncPhonePressed() {
        if userStatus == .isReady {
            WatchConnectivityManager.requestSyncWithPhone { (message) in
                if message == false {
                    self.userStatus = .syncFailed
                    DispatchQueue.main.async {
                        self.instructionLabel.setText("Workout not started on phone.")
                        self.syncButton.setTitle("Ok")
                        self.syncButton.setEnabled(true)
                    }
                } else {
                    self.userStatus = .isReady
                }
            }
            syncButton.setEnabled(false)
            DispatchQueue.main.async {
                self.instructionLabel.setText("Hold on...")
            }
        }
        
        if userStatus == .syncFailed {
            userStatus = .isReady
            DispatchQueue.main.async {
                self.instructionLabel.setText("Start Workout on Phone, then Sync")
                self.syncButton.setTitle("SYNC PHONE")
            }
        }
        
    }
}

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
        case syncTakingTooLong
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
                        self.syncButton.setTitle("OK")
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
            
            let when = DispatchTime.now() + 10.0
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.userStatus = .syncTakingTooLong
                self.instructionLabel.setText("Sync failed, try again.")
                self.syncButton.setEnabled(true)
                self.syncButton.setTitle("OK")
            })
        }
        
        if userStatus == .syncFailed {
            userStatus = .isReady
            DispatchQueue.main.async {
                self.instructionLabel.setText("Start Workout on Phone, then Sync")
                self.syncButton.setTitle("SYNC PHONE")
            }
        }
        
        if userStatus == .syncTakingTooLong {
            userStatus = .isReady
            DispatchQueue.main.async {
                WKInterfaceController.reloadRootPageControllers(withNames: ["Main"], contexts: nil, orientation: .horizontal, pageIndex: 0)
            }
        }
    }
}

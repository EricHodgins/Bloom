//
//  PhoneConnectivityManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import WatchConnectivity

class PhoneConnectivityManager: NSObject {
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    override init() {
        super.init()
        setupNotifications()
    }
    
    func setupNotifications() {
        notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationLiveWorkoutStarted), object: nil, queue: nil) { (notification) in
            if let dateStarted = notification.userInfo?["workoutStartDate"] as? NSDate {
                self.sendStateToWatch(date: dateStarted)
            }
        }
    }
    
    func sendStateToWatch(date: NSDate) {
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isWatchAppInstalled {
                do {
                    let dictionary = ["workoutStartDate" : date]
                    try session.updateApplicationContext(dictionary) // Application Context transfers only transfer the most recent dictionary of data over.
                } catch {
                    print("ERROR (sendStateToWatch): \(error)")
                }
            }
        }
    }

}

extension PhoneConnectivityManager: WCSessionDelegate {
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession Did Deactivate.")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession error: \(error.localizedDescription)")
            return
        }
        
        print("WCSession activation complete. activationState: \(activationState)")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
}

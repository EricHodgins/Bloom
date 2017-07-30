//
//  WorkoutSessionService.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-29.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//


import Foundation
import HealthKit

let hrUnit = HKUnit(from: "count/min")
let hrType: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!

class WorkoutSessionService: NSObject {
    
    fileprivate let healthService = HealthDataService()
    var startDate: Date?
    var endDate: Date?
    
    var heartRateQuery: HKQuery!
    var hrData: [HKQuantitySample] = [HKQuantitySample]()
    var heartRate: HKQuantity
    internal var hrAnchorValue: HKQueryAnchor?
    
    let hkWorkoutConfiguration: HKWorkoutConfiguration
    let session: HKWorkoutSession
    
    init?(configuration: HKWorkoutConfiguration) {
        
        self.hkWorkoutConfiguration = configuration
        
        do {
            session = try HKWorkoutSession(configuration: hkWorkoutConfiguration)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return nil
        }
        
        heartRate = HKQuantity(unit: hrUnit, doubleValue: 0.0)
        
        super.init()
        
        session.delegate = self
    }
    
    func startSession() {
        healthService.healthKitStore.start(session)
    }
    
    func stopSession() {
        healthService.healthKitStore.stop(heartRateQuery)
        healthService.healthKitStore.end(session)
    }
}

extension WorkoutSessionService: HKWorkoutSessionDelegate {
    fileprivate func sessionStarted(_ date: Date) {
        print("Session started.")
        heartRateQuery = heartRateQuery(withStartDate: Date())
        healthService.healthKitStore.execute(heartRateQuery)
    }
    
    fileprivate func sessionEnded(_ date: Date) {
        print("Session ended.")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout session did change state: \(toState.rawValue)-\(fromState.rawValue)")
        
        DispatchQueue.main.async {
            switch toState {
            case .running:
                self.sessionStarted(date)
            case .ended:
                self.sessionEnded(date)
            case .paused:
                break
            default:
                print("Something unexpected happened!")
            }
            
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Did fail with error: \(error)")
    }
    
}





























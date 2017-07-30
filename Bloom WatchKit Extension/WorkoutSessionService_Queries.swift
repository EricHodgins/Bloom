//
//  WorkoutSessionService_Queries.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-29.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//


import Foundation
import HealthKit
import WatchConnectivity


extension WorkoutSessionService {
    
    internal func heartRateQuery(withStartDate start: Date) -> HKQuery {
        let predicate = genericSamplePredicate(withStartDate: start)
        let query: HKAnchoredObjectQuery = HKAnchoredObjectQuery(type: hrType,
                                                                 predicate: predicate,
                                                                 anchor: hrAnchorValue,
                                                                 limit: Int(HKObjectQueryNoLimit)) {
                                                                    (query, sampleObjects, deletedObjects, newAnchor, error) in
                                                                    
                                                                    self.hrAnchorValue = newAnchor
                                                                    self.newHRSamples(sampleObjects)
                                                                    
        }
        
        query.updateHandler = { (query, samples, deleteObjects, newAnchor, error) in
            self.hrAnchorValue = newAnchor
            self.newHRSamples(samples)
        }
        
        return query
    }
    
    private func newHRSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample],
            samples.count > 0 else {
                return
        }
        
        DispatchQueue.main.async {
            self.hrData += samples
            
            if let hr = samples.last?.quantity {
                self.heartRate = hr
                print("heart rate = \(hr)")
                self.delegate?.workoutSessionService(didUpdateHeartRate: hr.doubleValue(for: hrUnit))
            }
        }
    }
    
    // MARK: - Helpers
    
    private func genericSamplePredicate(withStartDate start: Date) -> NSPredicate {
        let dataPredicate = HKQuery.predicateForSamples(withStart: start, end: nil, options: .strictStartDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [dataPredicate, devicePredicate])
    }
    
    func sendUpdatedHeartRateToPhone(hr: HKQuantity) {
        if WCSession.isSupported() {
            let session = WCSession.default()
            let hrValue = hr.doubleValue(for: hrUnit)
            if session.isReachable {
                let heartRateMessage = ["heart_rate": hrValue]
                
                session.sendMessage(heartRateMessage, replyHandler: nil, errorHandler: { (error) in
                    print("ERROR: \(error.localizedDescription)")
                })
            }
        }
    }
}





































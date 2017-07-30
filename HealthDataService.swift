//
//  HealthDataService.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-29.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import HealthKit

let heartRateType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!

class HealthDataService {
    
    internal let healthKitStore: HKHealthStore = HKHealthStore()
    
    init() {}
    
    func authorizeHealthKitAccess(_ completion: ((_ success: Bool, _ error: Error?) -> Void)!) {
        let typesToShare = Set(
            [HKObjectType.workoutType(), heartRateType]
        )
        
        let typesToSave = Set([heartRateType])
        
        healthKitStore.requestAuthorization(toShare: typesToShare, read: typesToSave) { (success, error) in
            completion(success, error)
        }
    }
    
    func workoutAuthorizationStatus() -> HKAuthorizationStatus {
        return healthKitStore.authorizationStatus(for: HKObjectType.workoutType())
    }
    
    func heartRateAuthorizationStatus() -> HKAuthorizationStatus {
        return healthKitStore.authorizationStatus(for: heartRateType)
    }
}

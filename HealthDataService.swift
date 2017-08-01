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
    let hrUnit = HKUnit(from: "count/min")
    
    init() {}
    
    func authorizeHealthKitAccess(_ completion: ((_ success: Bool, _ error: Error?) -> Void)!) {
        let typesToShare = Set(
            [HKObjectType.workoutType(), heartRateType]
        )
        
        let typesToRead = Set([heartRateType])
        
        healthKitStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    func workoutAuthorizationStatus() -> HKAuthorizationStatus {
        return healthKitStore.authorizationStatus(for: HKObjectType.workoutType())
    }
    
    func heartRateAuthorizationStatus() -> HKAuthorizationStatus {
        return healthKitStore.authorizationStatus(for: heartRateType)
    }
    
    func queryHeartRateData(withStartDate startDate: Date, toEndDate endDate: Date) {
        var heartRateQuery: HKSampleQuery?
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortDescriptors = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptors], resultsHandler: { (query, results, error) in
            
            guard error == nil else { print("Error: \(error?.localizedDescription ?? "No error msg")"); return }
            
            self.printQueriedResults(results: results)
            
        })
        
        
        healthKitStore.execute(heartRateQuery!)
    }
    
    //MARK: - Test Code, Remove later
    func printQueriedResults(results: [HKSample]?) {
        guard let results = results as? [HKQuantitySample] else { return }
        for sample in results {
            let hrValue = sample.quantity.doubleValue(for: hrUnit)
            print("Queried result: \(hrValue) - started: \(sample.startDate)")
        }
    }
}




















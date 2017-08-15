//
//  WorkoutSummary.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-15.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import HealthKit

protocol WorkoutSummarizer: class {
    func maxBPM() -> Double?
    func minBPM() -> Double?
    func avgBPM() -> Double?
    func durationString() -> String?
}

class WorkoutSummary: WorkoutSummarizer {
    
    private var healthService: HealthDataService
    private let hrUnit = HKUnit(from: "count/min")
    private var heartRateData: [Double]?
    var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
        self.healthService = HealthDataService()
    }
    
    private func queryHeartData() {
        guard let start = workout.startTime as Date?,
            let finish = workout.endTime as Date? else { return }
        
        healthService.queryHeartRateData(withStartDate: start, toEndDate: finish) { (samples) in
            guard let results = samples as? [HKQuantitySample] else { return }
            var dataSet: [Double] = []
            for sample in results {
                let hrValue = sample.quantity.doubleValue(for: self.hrUnit)
                dataSet.append(hrValue)
            }
            self.heartRateData = dataSet
        }
        
    }
    
    func maxBPM() -> Double? {
        guard let data = heartRateData,
          data.count > 0 else {
            return nil
        }
        
        let max = data.max()!
        return max
    }
    
    func minBPM() -> Double? {
        guard let data = heartRateData,
            data.count > 0 else {
                return nil
        }
        
        let min = data.min()!
        return min
    }
    
    func avgBPM() -> Double? {
        guard let data = heartRateData,
            data.count > 0 else {
                return nil
        }
        
        let avg = data.reduce(0, +) / Double(data.count)
        return avg
    }
    
    func durationString() -> String? {
        return nil
    }
}























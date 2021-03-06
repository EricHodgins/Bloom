//
//  WorkoutSummary.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-15.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import HealthKit
import CoreLocation

protocol WorkoutSummarizer: class {
    func maxBPM(bpm: Double?)
    func minBPM(bpm: Double?)
    func avgBPM(bpm: Double?)
    func totalDistance(inMetres metres: Measurement<UnitLength>)
}

class WorkoutSummary {
    
    private var healthService: HealthDataService
    private let hrUnit = HKUnit(from: "count/min")
    private var heartRateData: [Double]?
    var workout: Workout
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    
    
    weak var delegate: WorkoutSummarizer?
    
    init(workout: Workout) {
        self.workout = workout
        self.healthService = HealthDataService()
        queryHeartData()
        sendDistance()
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
            DispatchQueue.main.async {
                self.sendMaxBPM()
                self.sendMinBPM()
                self.sendAvgBPM()
            }
        }
        
    }
    
    private func sendMaxBPM() {
        guard let data = heartRateData,
          data.count > 0 else {
            delegate?.maxBPM(bpm: nil)
            return
        }
        
        let max = data.max()!
        delegate?.maxBPM(bpm: max)
    }
    
    private func sendMinBPM() {
        guard let data = heartRateData,
            data.count > 0 else {
                delegate?.minBPM(bpm: nil)
                return
        }
        
        let min = data.min()!
        delegate?.minBPM(bpm: min)
    }
    
    private func sendAvgBPM() {
        guard let data = heartRateData,
            data.count > 0 else {
                delegate?.avgBPM(bpm: nil)
                return
        }
        
        let avg = data.reduce(0, +) / Double(data.count)
        delegate?.avgBPM(bpm: avg)
    }
    
    private func sendDistance() {
        let locations = workout.locations?.array as! [Location]
        
        
        for (first, second) in zip(locations, locations.dropFirst()) {
            let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
            let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
            let delta = end.distance(from: start)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
        }
        
        DispatchQueue.main.async {
            self.delegate?.totalDistance(inMetres: self.distance)
        }
    }
    
    func durationString() -> String? {
        guard let start = workout.startTime,
            let end = workout.endTime else { return nil }
        
        let formattedDuration = start.delta(to: end)
        return formattedDuration
    }
}























//
//  HealthDataService_Watch.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-31.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import HealthKit

extension HealthDataService {
    //MARK: - Save workout data to health store
    func saveWorkout(workouSessionService: WorkoutSessionService) {
        guard let startDate = WorkoutManager.shared.workoutStartDate,
              let endDate = WorkoutManager.shared.workoutEndDate else {
                return
        }
        
        let workout = HKWorkout(activityType: .running, start: startDate as Date, end: endDate as Date)
        
        // Collect the sampled data
        var samples: [HKQuantitySample] = [HKQuantitySample]()
        samples += workouSessionService.hrData
        
        //Save workout
        healthKitStore.save(workout) { (success, error) in
            if !success || samples.count == 0 {
                print("Unsuccesful saving workout to HealthKit Store.")
                return
            }
            
            //Save Heart Samples if any
            self.healthKitStore.add(samples, to: workout) { (success: Bool, error: Error?) in
                guard error == nil else {
                    print("Error adding heart rate samples to workout: \(error?.localizedDescription ?? "No error message")")
                    return
                }
            }
        }
    }
}

//
//  WorkoutManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

class WorkoutManager {
    static let shared = WorkoutManager()
    private init() {}
    
    var workouts: [String] = []
    var currentExcercises: [String] = []
    private var currentExcercise: String?
    private var excerciseIndex: Int = 0
    var workoutStartDate: NSDate?
    var currentWorkout: String? {
        didSet {
            guard let workoutName = self.currentWorkout else { return }
            WatchConnectivityManager.requestExcercises(forWorkout: workoutName)
        }
    }
    
    func nextExcercise() -> String {
        excerciseIndex = (excerciseIndex + 1) % currentExcercises.count
        return currentExcercises[excerciseIndex]
    }
}

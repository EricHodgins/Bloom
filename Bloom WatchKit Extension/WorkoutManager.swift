//
//  WorkoutManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

protocol WorkoutsTableDelegate: class {
    func refreshTable()
}

protocol LiveWorkoutDelegate: class {
    func updateExcercises()
}

protocol RepsWeightDelegate: class {
    func updateReps()
    func updateWeight()
}

class WorkoutManager {
    static let shared = WorkoutManager()
    private init() {}
    
    weak var workoutTableDelegate: WorkoutsTableDelegate?
    weak var repsWeightDelegate: RepsWeightDelegate?
    weak var liveWorkoutDelegate: LiveWorkoutDelegate?
    
    var isStreamingHeartRateDataToPhone: Bool = false
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    var workouts: [String] = [] {
        didSet {
            workoutTableDelegate?.refreshTable()
        }
    }
    var currentExcercises: [String] = [] {
        didSet {
            liveWorkoutDelegate?.updateExcercises()
        }
    }
    fileprivate var currentExcercise: String?
    fileprivate var excerciseIndex: Int = 0
    var workoutStartDate: NSDate?
    var workoutEndDate: NSDate?
    var currentWorkout: String? {
        didSet {
            guard let workoutName = self.currentWorkout else { return }
            WatchConnectivityManager.requestExcercises(forWorkout: workoutName) { (excerciseNames) in
                self.currentExcercises = excerciseNames
                self.currentExcercise = self.currentExcercises[0]
                self.updateMaxReps()
                self.updateMaxWeight()
            }
        }
    }
    var reps: Double? = 10.0 {
        didSet {
            DispatchQueue.main.async {
                self.repsWeightDelegate?.updateReps()
            }
        }
    }
    var weight: Double? = 10.0 {
        didSet {
            DispatchQueue.main.async {
                self.repsWeightDelegate?.updateWeight()
            }
        }
    }
    var distance: Double?
    var timeRecorded: NSDate?
    
    func nextExcercise() -> String {
        excerciseIndex = (excerciseIndex + 1) % currentExcercises.count
        currentExcercise = currentExcercises[excerciseIndex]
        return currentExcercises[excerciseIndex]
    }
    
    func updateMaxReps() {
        guard let workout = currentWorkout,
            let excercise = currentExcercise else { return }
        
        WatchConnectivityManager.requestMaxReps(forExcercise: excercise, inWorkout: workout) { (maxReps) in
            self.reps = maxReps
        }
    }
    
    func updateMaxWeight() {
        guard let workout = currentWorkout,
            let excercise = currentExcercise else { return }
        
        WatchConnectivityManager.requestMaxWeight(forExcercise: excercise, inWorkout: workout) { (maxWeight) in
            self.weight = maxWeight
        }
    }
    
    func save() {
        let orderNumber = excerciseIndex
        
        if reps == nil {
            reps = 0.0
        }
        
        if weight == nil {
            weight = 0.0
        }
        
        if distance == nil {
            distance = 0.0
        }
        
        if timeRecorded == nil {
            timeRecorded = NSDate()
        }
        
        // This saves an excercise based on the order number
        WatchConnectivityManager.save(reps: reps!, weight: weight!, distance: distance!, time: timeRecorded!, orderNumber: orderNumber)
    }
}


extension WorkoutManager {
    func reset() {
        workoutTableDelegate = nil
        repsWeightDelegate = nil
        reps = nil
        weight = nil
        currentWorkout = nil
        workouts = []
        currentExcercises = []
        currentExcercise = nil
        excerciseIndex = 0
        workoutStartDate = nil
        workoutEndDate = nil
    }
}





















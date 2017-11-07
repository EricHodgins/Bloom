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
    func phoneRequestsNextExcercise(name: String)
    func updateExcercises()
}

protocol RepsWeightDelegate: class {
    func updateExcerciseValues()
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
    var activeExcercise: ActiveExcercise = ActiveExcercise(name: "", sets: "0", reps: "0", weight: "0", distance: "0", index: 0)
    var workoutStartDate: NSDate?
    var workoutEndDate: NSDate?
    var currentWorkout: String? {
        didSet {
            guard let workoutName = self.currentWorkout else { return }
            WatchConnectivityManager.requestExcercises(forWorkout: workoutName) { (excerciseNames) in
                self.currentExcercises = excerciseNames
                self.currentExcercise = self.currentExcercises[0]
                self.setupInitialExcerciseValues()
            }
        }
    }
    var sets: String? = "Sets: 0"
    var reps: String? = "Reps: 0"
    var weight: String? = "Weight: 0"
    var distance: String? = "Distance: 0"
    var timeRecorded: NSDate?
    
    func nextExcercise() -> String {
        excerciseIndex = (excerciseIndex + 1) % currentExcercises.count
        currentExcercise = currentExcercises[excerciseIndex]
        updatePhoneAndRequestNewExcerciseValues()
        activeExcercise.name = currentExcercises[excerciseIndex]
        return currentExcercises[excerciseIndex]
    }
    
    func phoneRequestsNextExcercise() {
        excerciseIndex = (excerciseIndex + 1) % currentExcercises.count
        currentExcercise = currentExcercises[excerciseIndex]
        liveWorkoutDelegate?.phoneRequestsNextExcercise(name: currentExcercises[excerciseIndex])
    }
    
    func udpateExcerciseValues() {
        phoneRequestsNextExcercise()
        repsWeightDelegate?.updateExcerciseValues()
    }
    
    private func setupInitialExcerciseValues() {
        WatchConnectivityManager.initialExcerciseValues {
            self.repsWeightDelegate?.updateExcerciseValues()
        }
    }
    
    private func updatePhoneAndRequestNewExcerciseValues() {
        WatchConnectivityManager.nextExcercise(excerciseIndex: excerciseIndex) {
            DispatchQueue.main.async {
                self.repsWeightDelegate?.updateExcerciseValues()
            }
        }
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





















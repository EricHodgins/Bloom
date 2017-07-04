//
//  WorkoutStateManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-03.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData

class WorkoutStateManager {
    
    static let shared = WorkoutStateManager()
    private init() {}
    
    var startedOnWatch: Bool = false
    
    var managedContext: NSManagedObjectContext?
    var startTime: NSDate?
    var workout: Workout?
    var workoutName: String?
    var excercises: [String]?
    var maxReps: Double?
    var maxWeight: Double?
    var maxDistance: Double?
    private var excerciseIndex: Int = 0
    
    func createNewWorkout() {
        
        guard let context = managedContext else { return }
        guard let workoutName = workoutName else { return }
        guard let excercises = excercises else { return }
        
        let workout = Workout(context: context)
        workout.name = workoutName
        
        for excercise in excercises {
            let exc = Excercise(context: context)
            exc.name = excercise
            workout.addToExcercises(exc)
        }
        
        self.workout = workout
    }
    
}

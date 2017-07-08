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
    
    var workoutProxy: WorkoutProxy?
    
    //initializes the proxy workout and creates an actual Workout
    // the proxy workout will get values from the watch and update the actual Workout.
    func createWorkout() {
        
        guard let context = managedContext else { return }
        guard let workoutName = workoutName else { return }
        guard let startTime = startTime else { return }
        guard let excercises = excercises else { return }
        
        let workout = Workout(context: context)
        workout.name = workoutName
        workout.startTime = startTime
        
        for excercise in excercises {
            let exc = Excercise(context: context)
            exc.name = excercise
            workout.addToExcercises(exc)
        }
        
        self.workout = workout
        
        workoutProxy = WorkoutProxy(workout: workout, managedContext: managedContext!)
    }
    
    func save(reps: Double, forOrderNumber orderNumber: Int16) {
        workoutProxy?.save(reps: reps, forOrderNumber: orderNumber)
    }
    
    func reset() {
        startedOnWatch = false
        startTime = nil
        workout = nil
        workoutName = nil
        excercises = nil
        maxReps = nil
        maxWeight = nil
        maxDistance = nil
        excerciseIndex = 0
        workoutProxy = nil
    }
}































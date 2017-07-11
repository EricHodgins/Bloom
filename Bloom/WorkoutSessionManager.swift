//
//  WorkoutSessionManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-10.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData

enum WorkoutSessionManagerState {
    case inactive
    case active
}

class WorkoutSessionManager {
    var state: WorkoutSessionManagerState = .inactive
    static let shared: WorkoutSessionManager = WorkoutSessionManager()
    private init() {}
    
    private var managedContext: NSManagedObjectContext!
    private var workout: Workout!
    
    func activate(managedContext: NSManagedObjectContext, workoutName: String, startDate: NSDate) {
        guard state == .inactive else { return }
        self.state = .active
        self.managedContext = managedContext
        
        createWorkout(name: workoutName, startDate: startDate)
    }
    
    private func createWorkout(name: String, startDate: NSDate) {
        let workout = Workout(context: managedContext)
        workout.name = name
        workout.startTime = startDate
        
        let workoutTemplate = BloomFilter.fetchWorkoutTemplate(forName: name, inManagedContext: managedContext)
        
        for excerciseTemplate in workoutTemplate.excercises! {
            let excercise = Excercise(context: managedContext)
            excercise.name = (excerciseTemplate as! ExcerciseTemplate).name!
            excercise.orderNumber = Int16((excerciseTemplate as! ExcerciseTemplate).orderNumber)
            workout.addToExcercises(excercise)
        }
        
        self.workout = workout
    }
    
    func excercises() -> [Excercise] {
        var excercises = [Excercise]()
        excercises = self.workout.excercises!.sorted { (e1, e2) -> Bool in
            return (e1 as! Excercise).orderNumber < (e2 as! Excercise).orderNumber
            } as! [Excercise]
        
        return excercises
    }
}

























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

enum WorkoutSessionDeviceInitiation {
    case phone
    case watch
    case none
}


class WorkoutSessionManager {
    var state: WorkoutSessionManagerState = .inactive
    static let shared: WorkoutSessionManager = WorkoutSessionManager()
    private init() {}
    
    var deviceInitiation: WorkoutSessionDeviceInitiation = .none
    fileprivate var managedContext: NSManagedObjectContext!
    var workout: Workout!
    var excercises: [Excercise] = []
    var currentExcercise: Excercise!
    
    func activate(managedContext: NSManagedObjectContext, workoutName: String, startDate: NSDate, deviceInitiated device: WorkoutSessionDeviceInitiation) {
        guard state == .inactive else { return }
        self.state = .active
        self.managedContext = managedContext
        self.deviceInitiation = device
        
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
        self.excercises = setExcercises()
        self.currentExcercise = self.excercises[0]
    }
    
    private func setExcercises() -> [Excercise] {
        var excercises = [Excercise]()
        excercises = self.workout.excercises!.sorted { (e1, e2) -> Bool in
            return (e1 as! Excercise).orderNumber < (e2 as! Excercise).orderNumber
            } as! [Excercise]
        
        return excercises
    }
    
    func nextExcercise() -> Excercise {
        let currentIndex = Int(currentExcercise.orderNumber)
        let newIndex = (currentIndex + 1) % excercises.count
        currentExcercise = excercises[newIndex]
        return currentExcercise
    }
    
    func reset() {
        //TODO: WIll need to reset
    }
}



//MARK: - For Watch Methods
extension WorkoutSessionManager {
    func save(reps: Double, forOrderNumber orderNumber: Int16) {
        for excercise in excercises {
            if excercise.orderNumber == orderNumber {
                excercise.reps = reps
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("save error: \(error), description: \(error.userInfo)")
        }
    }
}




















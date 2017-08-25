//
//  WorkoutSessionManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-10.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//
// This is mostly trying to keep phone and watch in sync

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
    var deviceInitiation: WorkoutSessionDeviceInitiation = .none
    
    fileprivate var managedContext: NSManagedObjectContext!
    var workout: Workout!
    var excercises: [Excercise] = []
    var currentExcercise: Excercise!
    
    weak var mapRouteDelegate: MapRouteDelegate?
    
    init(managedContext: NSManagedObjectContext, workoutName: String, startDate: NSDate, deviceInitiated device: WorkoutSessionDeviceInitiation) {
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
    
    func saveMapRoute() {
        mapRouteDelegate?.saveRoute()
    }
    
    fileprivate func reset() {
        state = .inactive
    }
}



//MARK: - For Watch Connectivity Methods
extension WorkoutSessionManager {
    private func excercise(forOrderNumber orderNumber: Int16) -> Excercise? {
        for excercise in excercises {
            if excercise.orderNumber == orderNumber {
                return excercise
            }
        }
        return nil
    }
    
    func save(reps: Double, weight: Double, distance: Double, time: NSDate, orderNumber: Int16) {
        guard let excercise = excercise(forOrderNumber: orderNumber) else { return }
        excercise.reps = reps
        excercise.weight = weight
        excercise.distance = distance
        excercise.timeRecorded = time
        save()
    }
    
    func save(reps: Double, forOrderNumber orderNumber: Int16) {
        guard let excercise = excercise(forOrderNumber: orderNumber) else { return }
        excercise.reps = reps
        save()
    }
    
    func save(weight: Double, forOrderNumber orderNumber: Int16) {
        guard let excercise = excercise(forOrderNumber: orderNumber) else { return }
        excercise.weight = weight
        save()
    }
    
    func save(finishedDate date: NSDate) {
        workout.endTime = date
        save()
        reset()
    }
    
    func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("save error: \(error), description: \(error.userInfo)")
        }
    }
}




















//
//  PhoneWorkoutManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-06.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData

class WorkoutProxy {
    
    var workout: Workout
    var managedContext: NSManagedObjectContext
    
    lazy var excercises: [Excercise] = {
        var excercises = [Excercise]()
        excercises = self.workout.excercises!.sorted { (e1, e2) -> Bool in
            return (e1 as! Excercise).orderNumber < (e2 as! Excercise).orderNumber
            } as! [Excercise]
        
        return excercises
    }()
    
    init(workout: Workout, managedContext: NSManagedObjectContext) {
        self.workout = workout
        self.managedContext = managedContext
    }
    
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

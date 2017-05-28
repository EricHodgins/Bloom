//
//  CoreDataTest.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-05-28.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData

class CoreDataTest {
    var managedContext: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    func printAllWorkoutTemplates(printExcercises: Bool = false) {
        let fetchRequest = NSFetchRequest<WorkoutTemplate>(entityName: "WorkoutTemplate")
        
        do {
            print("============== Core Data Test ===============")
            let worktoutTemplates = try managedContext.fetch(fetchRequest)
            for template in worktoutTemplates {
                print("\(String(describing: template.name!))")
                if printExcercises {
                    for e in template.excercises! {
                        let excer = e as! ExcerciseTemplate
                        print("\t\(excer.name!)")
                    }
                }
            }
            print("========== Done Core Data Print Test ========")
        } catch let error as NSError {
            print("Fetch error: \(error), description: \(error.userInfo)")
        }
    }
    
    func printAllWorkoutTemplatesAndExcercises() {
        printAllWorkoutTemplates(printExcercises: true)
    }
    
    func printAllWorkouts(printExcercises: Bool = false) {
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        
        do {
            print("============== Core Data Test ===============")
            let workouts = try managedContext.fetch(fetchRequest)
            for workout in workouts {
                print("\(workout.name!)")
                if printExcercises {
                    for excercise in workout.excercises! {
                        let e = excercise as! Excercise
                        print("\t\(e.name!), Reps: \(e.reps)")
                    }
                }
            }
            print("========== Done Core Data Print Test ========")
        } catch let error as NSError {
            print("Fetch error: \(error), description: \(error.userInfo)")
        }
    }
    
    func printAllWorkoutsAndExcercises() {
        printAllWorkouts(printExcercises: true)
    }
    
}

































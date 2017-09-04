//
//  Validator.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-09-03.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData

enum Validation {
    case isEmpty
    case alreadyExists
    case pass
    case error
}

struct Validate {
    static func workout(name: String?, inManagedContext context: NSManagedObjectContext) -> Validation {
        guard let name = name else { return Validation.isEmpty }
        if name == "" { return Validation.isEmpty }
        
        let workoutFetch: NSFetchRequest<WorkoutTemplate> = WorkoutTemplate.fetchRequest()
        workoutFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(WorkoutTemplate.name), name)
        
        do {
            let results = try context.fetch(workoutFetch)
            if results.count > 0 {
                return Validation.alreadyExists
            } else {
                return Validation.pass
            }
        } catch let error as NSError {
            print("Error fetching workout: \(error.localizedDescription)")
            return Validation.error
        }
    }
    
    static func exercercise(name: String?) -> Validation {
        guard let name = name else { return .isEmpty }
        if name == "" { return Validation.isEmpty }
        return Validation.pass
    }
    
//    func isCheckedAndTrimmedWorkoutNamePassed() -> Bool {
//        if self.workoutNameTextfield.text != "" {
//            let workoutName = self.workoutNameTextfield.text!.removeExtraWhiteSpace
//            let workoutFetch: NSFetchRequest<WorkoutTemplate> = WorkoutTemplate.fetchRequest()
//            workoutFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(WorkoutTemplate.name), workoutName)
//            
//            do {
//                let results = try self.managedContext.fetch(workoutFetch)
//                if results.count > 0 {
//                    //Alert Notifying a workout is already named that.
//                    present(AlertManager.alert(title: "Workout already exists.", message: "A workout is already named that. Please choose a different name.", style: .alert), animated: true)
//                    return false
//                } else {
//                    // If editing an existing workout template don't create new one.
//                    guard !self.isEditingExistingWorkout else {
//                        self.updateWorkoutTemplate(workoutName: workoutName)
//                        return true
//                    }
//                    // Brand New Workout Named -> Create a new workout with this name
//                    self.navigationController?.title = workoutName
//                    self.currentWorkout = WorkoutTemplate(context: self.managedContext)
//                    self.currentWorkout?.name = workoutName
//                    
//                    return true
//                }
//            } catch let error as NSError {
//                print("Fetch error: \(error), \(error.userInfo)")
//            }
//        } else {
//            //Alert - Workout name has not been named
//            present(AlertManager.alert(title: "A workout must have a name.", message: "Please name your workout.", style: .alert), animated: true)
//            return false
//        }
//        
//        present(AlertManager.alert(title: "Workout Name is Blank.", message: "Please name your workout.", style: .alert), animated: true)
//        return false
//    }

}

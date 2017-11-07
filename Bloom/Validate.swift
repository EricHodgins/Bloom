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
}

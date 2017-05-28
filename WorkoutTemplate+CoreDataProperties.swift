//
//  WorkoutTemplate+CoreDataProperties.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-05-27.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData


extension WorkoutTemplate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutTemplate> {
        return NSFetchRequest<WorkoutTemplate>(entityName: "WorkoutTemplate")
    }

    @NSManaged public var name: String?
    @NSManaged public var excercises: NSSet?

}

// MARK: Generated accessors for excercises
extension WorkoutTemplate {

    @objc(addExcercisesObject:)
    @NSManaged public func addToExcercises(_ value: ExcerciseTemplate)

    @objc(removeExcercisesObject:)
    @NSManaged public func removeFromExcercises(_ value: ExcerciseTemplate)

    @objc(addExcercises:)
    @NSManaged public func addToExcercises(_ values: NSSet)

    @objc(removeExcercises:)
    @NSManaged public func removeFromExcercises(_ values: NSSet)

}

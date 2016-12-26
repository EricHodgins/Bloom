//
//  Workout+CoreDataProperties.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-24.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout");
    }

    @NSManaged public var name: String?
    @NSManaged public var excercises: NSOrderedSet?

}

// MARK: Generated accessors for excercises
extension Workout {

    @objc(addExcercisesObject:)
    @NSManaged public func addToExcercises(_ value: Excercise)

    @objc(removeExcercisesObject:)
    @NSManaged public func removeFromExcercises(_ value: Excercise)

    @objc(addExcercises:)
    @NSManaged public func addToExcercises(_ values: NSSet)

    @objc(removeExcercises:)
    @NSManaged public func removeFromExcercises(_ values: NSSet)

}

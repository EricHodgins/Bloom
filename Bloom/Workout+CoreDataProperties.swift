//
//  Workout+CoreDataProperties.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-05-28.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var name: String?
    @NSManaged public var startTime: NSDate?
    @NSManaged public var endTime: NSDate?
    @NSManaged public var excercises: NSOrderedSet?

}

// MARK: Generated accessors for excercises
extension Workout {

    @objc(insertObject:inExcercisesAtIndex:)
    @NSManaged public func insertIntoExcercises(_ value: Excercise, at idx: Int)

    @objc(removeObjectFromExcercisesAtIndex:)
    @NSManaged public func removeFromExcercises(at idx: Int)

    @objc(insertExcercises:atIndexes:)
    @NSManaged public func insertIntoExcercises(_ values: [Excercise], at indexes: NSIndexSet)

    @objc(removeExcercisesAtIndexes:)
    @NSManaged public func removeFromExcercises(at indexes: NSIndexSet)

    @objc(replaceObjectInExcercisesAtIndex:withObject:)
    @NSManaged public func replaceExcercises(at idx: Int, with value: Excercise)

    @objc(replaceExcercisesAtIndexes:withExcercises:)
    @NSManaged public func replaceExcercises(at indexes: NSIndexSet, with values: [Excercise])

    @objc(addExcercisesObject:)
    @NSManaged public func addToExcercises(_ value: Excercise)

    @objc(removeExcercisesObject:)
    @NSManaged public func removeFromExcercises(_ value: Excercise)

    @objc(addExcercises:)
    @NSManaged public func addToExcercises(_ values: NSOrderedSet)

    @objc(removeExcercises:)
    @NSManaged public func removeFromExcercises(_ values: NSOrderedSet)

}

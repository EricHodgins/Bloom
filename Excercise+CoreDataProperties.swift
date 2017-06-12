//
//  Excercise+CoreDataProperties.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-10.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData


extension Excercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Excercise> {
        return NSFetchRequest<Excercise>(entityName: "Excercise")
    }

    @NSManaged public var distance: Double
    @NSManaged public var name: String?
    @NSManaged public var orderNumber: Int16
    @NSManaged public var reps: Double
    @NSManaged public var timeRecorded: NSDate?
    @NSManaged public var weight: Double
    @NSManaged public var workout: Workout?

}

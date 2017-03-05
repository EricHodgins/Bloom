//
//  Excercise+CoreDataProperties.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-02-04.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData


extension Excercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Excercise> {
        return NSFetchRequest<Excercise>(entityName: "Excercise");
    }

    @NSManaged public var name: String?
    @NSManaged public var reps: Double
    @NSManaged public var weight: Double
    @NSManaged public var distance: Double
    @NSManaged public var workout: Workout?

}

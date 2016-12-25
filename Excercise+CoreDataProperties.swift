//
//  Excercise+CoreDataProperties.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-24.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData


extension Excercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Excercise> {
        return NSFetchRequest<Excercise>(entityName: "Excercise");
    }

    @NSManaged public var name: String?
    @NSManaged public var workout: Workout?

}

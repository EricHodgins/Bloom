//
//  ExcerciseTemplate+CoreDataProperties.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-10.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData


extension ExcerciseTemplate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExcerciseTemplate> {
        return NSFetchRequest<ExcerciseTemplate>(entityName: "ExcerciseTemplate")
    }

    @NSManaged public var name: String?
    @NSManaged public var orderNumber: Int16
    @NSManaged public var workout: WorkoutTemplate?

}

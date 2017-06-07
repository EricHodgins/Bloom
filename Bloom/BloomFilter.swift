//
//  BloomFilter.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-05.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData

class BloomFilter {
    
    lazy var workoutForNamePredicate = { (workoutName: String) -> NSPredicate in
        return NSPredicate(format: "%K == %@", #keyPath(Excercise.workout.name), workoutName)
    }
    
    lazy var excerciseNamePredicate = { (excerciseName:String) -> NSPredicate in
        return NSPredicate(format: "%K == %@", #keyPath(Excercise.name), excerciseName)
    }
    
    lazy var workoutDateSortDescriptor: NSSortDescriptor = {
        return NSSortDescriptor(key: #keyPath(Excercise.workout.startTime), ascending: true)
    }()
    
    lazy var datePredicate = { (start: Date, end: Date) -> NSPredicate in
        var startDate = start
        var endDate = end
        if startDate > endDate {
            let tempDate = startDate
            startDate = endDate
            endDate = tempDate
        }
        let predicate = NSPredicate(format: "%K >= %@ && %K <= %@", #keyPath(Excercise.workout.startTime), startDate as NSDate, #keyPath(Excercise.workout.startTime), endDate as NSDate)
        
        return predicate
    }
    
    lazy var maxRepsExpressionDescription: NSExpressionDescription = {
        let maxRepExpressionDesc = NSExpressionDescription()
        maxRepExpressionDesc.name = "maxReps"
        
        let excerciseRepsDesc = NSExpression(forKeyPath: #keyPath(Excercise.reps))
        maxRepExpressionDesc.expression = NSExpression(forFunction: "max:", arguments: [excerciseRepsDesc])
        
        maxRepExpressionDesc.expressionResultType = .doubleAttributeType
        
        return maxRepExpressionDesc
    }()

}


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
    
    lazy var maxWeightExpressionDescription: NSExpressionDescription = {
        let maxRepExpressionDesc = NSExpressionDescription()
        maxRepExpressionDesc.name = "maxWeight"
        
        let excerciseRepsDesc = NSExpression(forKeyPath: #keyPath(Excercise.weight))
        maxRepExpressionDesc.expression = NSExpression(forFunction: "max:", arguments: [excerciseRepsDesc])
        
        maxRepExpressionDesc.expressionResultType = .doubleAttributeType
        
        return maxRepExpressionDesc
    }()
    
    func allWorkouts(inManagedContext managedContext: NSManagedObjectContext) -> [WorkoutTemplate] {
        let fetchRequest = NSFetchRequest<WorkoutTemplate>(entityName: "WorkoutTemplate")
        var workouts: [WorkoutTemplate] = []
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Save error: \(error), description: \(error.userInfo)")
        }
        return workouts
    }
    
    func fetchMaxReps(forExcercise excercise: String, inWorkout workout: String, withManagedContext managedContext: NSManagedObjectContext) -> Double {
        let fetchRequest: NSFetchRequest<NSDictionary>
        fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Excercise")
        fetchRequest.resultType = .dictionaryResultType
        
        let workoutNamePredicate = workoutForNamePredicate(workout)
        let excercisenamePredicate = excerciseNamePredicate(excercise)
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [workoutNamePredicate, excercisenamePredicate])
        
        let repsExpressDescription = maxRepsExpressionDescription
        fetchRequest.propertiesToFetch = [repsExpressDescription]
        
        var maxValue: Double?
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultDict = results.first!
            maxValue = resultDict["maxReps"] as? Double
            print("Max Reps: \(maxValue ?? 0)")
        } catch let error as NSError {
            print("NSDescription Error: \(error.userInfo)")
        }
        
        return maxValue ?? 0
    }
    
    func fetchMaxWeight(forExcercise excercise: String, inWorkout workout: String, withManagedContext managedContext: NSManagedObjectContext) -> Double {
        let fetchRequest: NSFetchRequest<NSDictionary>
        fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Excercise")
        fetchRequest.resultType = .dictionaryResultType
        
        let workoutNamePredicate = workoutForNamePredicate(workout)
        let excercisenamePredicate = excerciseNamePredicate(excercise)
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [workoutNamePredicate, excercisenamePredicate])
        
        let weightExpressDescription = maxWeightExpressionDescription
        fetchRequest.propertiesToFetch = [weightExpressDescription]
        
        var maxValue: Double?
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultDict = results.first!
            maxValue = resultDict["maxWeight"] as? Double
            print("Max Weight: \(maxValue ?? 0)")
        } catch let error as NSError {
            print("NSDescription Error: \(error.userInfo)")
        }
        
        return maxValue ?? 0
    }
    
    
    class func excercises(forWorkout workoutName: String, inManagedContext managedContext: NSManagedObjectContext) -> [String] {
        let fetchRequest = NSFetchRequest<WorkoutTemplate>(entityName: "WorkoutTemplate")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(WorkoutTemplate.name), workoutName)
        fetchRequest.predicate = predicate
        var workouts: [WorkoutTemplate] = []
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Workout fetch error: \(error), \(error.localizedDescription)")
        }
        
        let workoutTemplate = workouts.first!
        let excercises: [ExcerciseTemplate] = workoutTemplate.excercises!.sorted { (e1, e2) -> Bool in
                return (e1 as! ExcerciseTemplate).orderNumber < (e2 as! ExcerciseTemplate).orderNumber
        } as! [ExcerciseTemplate]
        
        
        var ordererdExcercises: [String] = []
        for excercise in excercises {
            ordererdExcercises.append(excercise.name!)
        }
        
        return ordererdExcercises
    }
    
    class func fetchWorkoutTemplate(forName name: String, inManagedContext managedContext: NSManagedObjectContext) -> WorkoutTemplate {
        let fetchRequest = NSFetchRequest<WorkoutTemplate>(entityName: "WorkoutTemplate")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(WorkoutTemplate.name), name)
        fetchRequest.predicate = predicate
        
        var workouts: [WorkoutTemplate] = []
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch workoutTemplate: \(error.localizedDescription)")
        }
        
        let workoutTemplate: WorkoutTemplate = workouts.first!
        
        return workoutTemplate
    }
    
    class func fetchLastWorkout(inManagedContext managedContext: NSManagedObjectContext) -> Workout? {
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Workout.startTime), ascending: false)]
        fetchRequest.fetchLimit = 1
        
        var workout: [Workout] = []
        do {
            workout = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch latest workout: \(error.localizedDescription)")
        }
        
        if workout.count == 0 { return nil }
        
        return workout.first!
    }
    
    class func fetchAllExcercises(inManagedContext managedContext: NSManagedObjectContext) -> [String]? {
        let fetchRequest = NSFetchRequest<ExcerciseTemplate>(entityName: "ExcerciseTemplate")
        
        var excercises: [ExcerciseTemplate] = []
        do {
            excercises = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch all excercises: \(error.localizedDescription)")
        }
        
        guard excercises.count != 0 else { return nil }
        
        var names: [String] = []
        for excercise in excercises {
            names.append(excercise.name!)
        }
        
        let setNames = Set(names)
        var arrayNames = Array(setNames)
        arrayNames.sort()
        
        return arrayNames
    }
    
    //MARK: - Location Queries
    class func fetchLocations(startDate: Date, finishDate: Date, inManagedContext managedContext: NSManagedObjectContext) -> [Location] {
        
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
        let datePredicate = NSPredicate(format: "%K >= %@ && %K <= %@", #keyPath(Location.timeStamp), startDate as NSDate, #keyPath(Location.timeStamp), finishDate as NSDate)
        
        fetchRequest.predicate = datePredicate
        var locations: [Location] = []
        
        do {
            locations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch location objects: \(error.localizedDescription)")
        }
        
        return locations
    }

}














//
//  CoreDataStack.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-24.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    fileprivate lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else  { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

extension CoreDataStack {
    // This will remove ExcerciseTemplate objects that have no relationship to a workout.  probably because they were deleted from an original workout created.
    public func performCleanUp() {
        storeContainer.performBackgroundTask { (managedContext) in
            
            let fetchRequest = NSFetchRequest<ExcerciseTemplate>(entityName: "ExcerciseTemplate")
            let predicate = NSPredicate(format: "%K == nil", #keyPath(ExcerciseTemplate.workout))
            fetchRequest.predicate = predicate
            
            var excerciseTemplates: [ExcerciseTemplate] = []
            
            do {
                excerciseTemplates = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Error fetching excercise templates with workout rel. nil: \(error.localizedDescription)")
            }
            
            for excercise in excerciseTemplates {
                managedContext.delete(excercise)
            }
            
            managedContext.perform {
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Error saving clean core data: \(error.localizedDescription)")
                }
                self.saveContext()
            }
        }
    }
    
    public func exportCSVFile(completion: @escaping ((_ url: URL?) -> Void)) {
        storeContainer.performBackgroundTask { (managedContext) in
            let allWorkouts = BloomFilter.fetchAllWorkouts(inManagedContext: managedContext)
            guard let workouts = allWorkouts else {
                completion(nil)
                return
            }
            
            //Export File path
            let exportFilePath = NSTemporaryDirectory() + "bloom_workout_data.csv"
            let exportFileURL = URL(fileURLWithPath: exportFilePath)
            FileManager.default.createFile(atPath: exportFilePath, contents: Data(), attributes: nil)
            
            // Now write to disk
            let fileHandle: FileHandle?
            do {
                fileHandle = try FileHandle(forWritingTo: exportFileURL)
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                fileHandle = nil
            }
            
            let weightUnit = Metric.weightMetricString()
            let distanceUnit = Metric.distanceMetricString()
            
            let headerRow = "Workout, Start Date, End Date, Duration, Exercise, Sets, Reps, Weight (\(weightUnit)), Distance (\(distanceUnit)), Excercise Time Completed\n"
            let headerRowData = headerRow.data(using: .utf8, allowLossyConversion: false)!
            
            if let fileHandle = fileHandle {
                fileHandle.write(headerRowData)
                for workout in workouts {
                    fileHandle.seekToEndOfFile()
                    if let lines = workout.csvArray() {
                        for line in lines {
                            if let csvData = line.data(using: .utf8, allowLossyConversion: false) {
                                fileHandle.write(csvData)
                            }
                        }
                    }
                }
                fileHandle.closeFile()
                completion(exportFileURL)
            }
        }
    }
}

extension Workout {
    func csvArray() -> [String]? {
        let weightMetric: String = Metric.weightMetricString()
        let distanceMetric: String = Metric.distanceMetricString()

        var workoutLines: [String] = []
        let workoutName = name ?? ""
        let startDate = startTime?.dateString(withTime: true) ?? ""
        let endDate = endTime?.dateString(withTime: true) ?? ""
        let duration: String
        if let start = self.startTime, let end = self.endTime {
            duration = start.delta(to: end)
        } else {
            duration = ""
        }
        
        guard let excercisesSet = self.excercises else {
            return nil
        }
        let excercises = Array(excercisesSet) as! [Excercise]
        
        for excercise in excercises {
            let name = excercise.name ?? ""
            let sets = excercise.sets
            let reps = excercise.reps
            
            var selectedWeightLocale = Measurement(value: excercise.weight, unit: UnitMass.kilograms)
            if weightMetric == "lbs" {
                selectedWeightLocale = selectedWeightLocale.converted(to: UnitMass.pounds)
            }
            
            var selectedDistanceLocale = Measurement(value: excercise.distance, unit: UnitLength.kilometers)
            if distanceMetric == "mi" {
                selectedDistanceLocale = selectedDistanceLocale.converted(to: UnitLength.miles)
            }

            let timeComplete = excercise.timeRecorded?.dateString(withTime: true) ?? ""
            let line = "\(workoutName), \(startDate), \(endDate), \(duration), \(name), \(sets), \(reps), \(selectedWeightLocale.value), \(selectedDistanceLocale.value), \(timeComplete)\n"
            workoutLines.append(line)
        }
        return workoutLines
    }
}
















//
//  CSVExporter.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-09-25.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import CoreData

class CSVExporter {
    
    var managedContext: NSManagedObjectContext!
    
    init(withManagedContext managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func emailCSV(completion: @escaping ((_ url: URL?) -> Void)) {
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

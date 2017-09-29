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
            
            let csvExporter = CSVExporter(withManagedContext: managedContext)
            csvExporter.emailCSV(completion: { (url) in
                completion(url)
            })
        }
    }
}


















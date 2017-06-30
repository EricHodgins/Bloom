//
//  WorkoutInterfaceController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-26.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import WatchKit
import Foundation
import CoreData


class WorkoutInterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!
    
    lazy var coreDataStack: CoreDataStack = {
        return CoreDataStack(modelName: "Bloom")
    }()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        fetchWorkouts()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func fetchWorkouts() {
        let fetchRequest = NSFetchRequest<WorkoutTemplate>(entityName: "WorkoutTemplate")
        
        do {
            let workouts = try coreDataStack.managedContext.fetch(fetchRequest)
            print(workouts)
        } catch let error as NSError {
            print("Save error: \(error), description: \(error.userInfo)")
        }
    }

}

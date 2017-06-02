//
//  GraphViewController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-05-31.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class GraphViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    var chestWorkouts: [Excercise] = []
    var dataSet: [Double] = []
    
    @IBOutlet weak var graphView: GraphView!
    
    lazy var chestWorkoutRepsPredicate: NSPredicate = {
        return NSPredicate(format: "%K == %@", #keyPath(Excercise.workout.name), "Chest")
    }()
    
    lazy var datePredicate: NSPredicate = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let startDate = formatter.date(from: "2017-04-01 00:00:00")! as NSDate
        let endDate = formatter.date(from: "2017-04-30 00:00:00")! as NSDate

        let predicate = NSPredicate(format: "%K >= %@ && %K <= %@", #keyPath(Excercise.workout.startTime), startDate, #keyPath(Excercise.workout.startTime), endDate)
        
        return predicate
    }()
    
    lazy var workoutDateSortDescriptor: NSSortDescriptor = {
        return NSSortDescriptor(key: #keyPath(Excercise.workout.startTime), ascending: true)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testFindAllChestWorkouts()
    }
    
    func testFindAllChestWorkouts() {
        let fetchRequest: NSFetchRequest<Excercise> = Excercise.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [chestWorkoutRepsPredicate, datePredicate])
        fetchRequest.sortDescriptors = [workoutDateSortDescriptor]
        
        do {
            chestWorkouts = try managedContext.fetch(fetchRequest)
            poChestWorkouts(excercises: chestWorkouts)
        } catch let error as NSError {
            print("Chest workout fetch error: \(error), \(error.userInfo)")
        }
    }
    
    func poChestWorkouts(excercises: [Excercise]) {
        for excercise in excercises {
            print("\(excercise.reps) - \(String(describing: excercise.workout?.startTime))")
            dataSet.append(excercise.reps)
        }
        graphView.dataSet = dataSet
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        graphView.setNeedsDisplay()
    }
    
}



















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
    var fetchRequest: NSFetchRequest<Excercise>!
    var workoutName: String!
    var endDate: NSDate = NSDate()
    var startDate: NSDate!
    var excercises: [Excercise] = []
    var dataSet: [Double] = []
    
    @IBOutlet weak var graphView: GraphView!
    
    lazy var workoutForNamePredicate: NSPredicate = {
        return NSPredicate(format: "%K == %@", #keyPath(Excercise.workout.name), self.workoutName)
    }()
    
    lazy var datePredicate: NSPredicate = {
        let predicate = NSPredicate(format: "%K >= %@ && %K <= %@", #keyPath(Excercise.workout.startTime), self.startDate, #keyPath(Excercise.workout.startTime), self.endDate)
        
        return predicate
    }()
    
    lazy var workoutDateSortDescriptor: NSSortDescriptor = {
        return NSSortDescriptor(key: #keyPath(Excercise.workout.startTime), ascending: true)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let threeMonthsAgoFromToday = Calendar.current.date(byAdding: .month, value: -3, to: Date())! as NSDate
        startDate = threeMonthsAgoFromToday
        
        fetchExcercises()
    }
    
    func fetchExcercises() {
        let fetchRequest: NSFetchRequest<Excercise> = Excercise.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [workoutForNamePredicate, datePredicate])
        fetchRequest.sortDescriptors = [workoutDateSortDescriptor]
        
        do {
            excercises = try managedContext.fetch(fetchRequest)
            loadGraphDataSet(excercises: excercises)
        } catch let error as NSError {
            print("Chest workout fetch error: \(error), \(error.userInfo)")
        }
    }
    
    func loadGraphDataSet(excercises: [Excercise]) {
        dataSet = []
        for excercise in excercises {
            dataSet.append(excercise.reps)
        }
        graphView.dataSet = dataSet
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        graphView.setNeedsDisplay()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Filter" {
            if let navController = segue.destination as? UINavigationController,
            let filterController = navController.topViewController as? FilterGraphController {
                filterController.workoutName = workoutName
                filterController.delegate = self
            }
        }
    }
    
}

extension GraphViewController: FilterViewControllerDelegate {
    func filter(withPredicates predicates: [NSPredicate], sortDescriptor: [NSSortDescriptor]) {
        fetchRequest = Excercise.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        fetchRequest.sortDescriptors = sortDescriptor
        
        do {
            excercises = try managedContext.fetch(fetchRequest)
            loadGraphDataSet(excercises: excercises)
        } catch let error as NSError {
            print("Filter fetch error: \(error.userInfo)")
        }
    }
}

















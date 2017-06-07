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
    var excerciseName: String!
    var endDate: NSDate = NSDate()
    var startDate: NSDate!
    var excercises: [Excercise] = []
    var dataSet: [Double] = []
    
    @IBOutlet weak var graphView: GraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = excerciseName
        let threeMonthsAgoFromToday = Calendar.current.date(byAdding: .month, value: -3, to: Date())! as NSDate
        startDate = threeMonthsAgoFromToday
        
        fetchRequest = Excercise.fetchRequest()
        fetchExcercises()
    }
    
    func fetchExcercises() {
        
        let bloomFilter = BloomFilter()
        let workoutNamePredicate = bloomFilter.workoutForNamePredicate(workoutName)
        let excercisenamePredicate = bloomFilter.excerciseNamePredicate(excerciseName)
        let datePredicate = bloomFilter.datePredicate(startDate as Date, endDate as Date)
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [workoutNamePredicate, excercisenamePredicate, datePredicate])
        fetchRequest.sortDescriptors = [bloomFilter.workoutDateSortDescriptor]
        
        
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
                filterController.excerciseName = excerciseName
                filterController.delegate = self
            }
        }
    }
    
}

extension GraphViewController: FilterViewControllerDelegate {
    func filter(withPredicates predicates: [NSPredicate], sortDescriptor: [NSSortDescriptor]) {
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

















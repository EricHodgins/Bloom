//
//  SummaryViewController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-05-31.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class SummaryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var managedContext: NSManagedObjectContext!
    var workouts: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        fetch()
    }
    
    func fetch() {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "WorkoutTemplate")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(WorkoutTemplate.name), ascending: true)]
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = ["name"]
        
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Workout template fetch error: \(error.userInfo)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExcercises" {
            let excerciseController = segue.destination as! ExcercisesController
            let cellIndex = tableView.indexPathForSelectedRow!
            excerciseController.managedContext = managedContext
            excerciseController.workoutName = workouts[cellIndex.row]["name"] as! String
        }
    }
}

// Table View Delegate
extension SummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = workouts[indexPath.row]["name"] as? String
        return cell
    }
}

























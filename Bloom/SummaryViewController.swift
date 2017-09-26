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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var csvBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    var managedContext: NSManagedObjectContext!
    var workoutTypes: [NSDictionary] = []
    var workouts: [Workout] = []
    var isAllWorkouts: Bool = false
    
    var dateFormatter: DateFormatter!
    
    var fetchedResultsController: NSFetchedResultsController<NSDictionary>!
    var fetchedResultsControllerAll: NSFetchedResultsController<Workout>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IAPManager.shared.isCSVPurchased {
            csvBarButtonItem.isEnabled = true
        }
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.boldSystemFont(ofSize: 25)
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        
        deleteBarButtonItem.isEnabled = false
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.cornerRadius = 8.0
        segmentedControl.layer.masksToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        fetchWorkoutTypes()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let rootVC = navigationController?.viewControllers[0]
        rootVC?.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        rootVC?.navigationController?.navigationBar.shadowImage = nil
    }
    
    func fetchWorkoutTypes() {
        guard fetchedResultsController == nil else { return }
        
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "WorkoutTemplate")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(WorkoutTemplate.name), ascending: true)]
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = ["name"]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
           print("Workout template fetch error: \(error.userInfo)")
        }
    }
    
    func fetchAllWorkouts() {
        guard fetchedResultsControllerAll == nil else { return }
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Workout.name), ascending: true)]
        
        fetchedResultsControllerAll = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: #keyPath(Workout.name), cacheName: nil)
        
        fetchedResultsControllerAll.delegate = self
        
        do {
            try fetchedResultsControllerAll.performFetch()
        } catch let error as NSError {
            print("All workout fetch error: \(error.userInfo)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExcercises" {
            let excerciseController = segue.destination as! ExcercisesController
            let indexPath = tableView.indexPathForSelectedRow!
            let workoutDict = fetchedResultsController.object(at: indexPath)
            
            excerciseController.managedContext = managedContext
            excerciseController.workoutName = workoutDict["name"] as? String
        }
        
        if segue.identifier == "ShowWorkoutStats" {
            let workoutDetailController = segue.destination as! WorkoutDetailController
            let workout = fetchedResultsControllerAll.object(at: tableView.indexPathForSelectedRow!)
            workoutDetailController.workout = workout
            workoutDetailController.managedContext = managedContext
        }
    }
    
    @IBAction func segmentControllPressed(_ sender: UISegmentedControl) {
        segmentControlValueChanged(segment: sender)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if tableView.isEditing {
            deleteBarButtonItem.title = "Delete"
            deleteBarButtonItem.tintColor = UIColor(displayP3Red: 255/255, green: 0, blue: 0, alpha: 1.0)
            tableView.setEditing(false, animated: true)
        } else {
            deleteBarButtonItem.title = "Done"
            deleteBarButtonItem.tintColor = UIColor(displayP3Red: 61/255, green: 157/255, blue: 148/255, alpha: 1.0)
            tableView.setEditing(true, animated: true)
        }
    }
}

// Table View Delegate
extension SummaryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.0369855836, green: 0.5332083106, blue: 0.9984238744, alpha: 1)
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isAllWorkouts {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isAllWorkouts {
            let sectionInfo = fetchedResultsControllerAll.sections?[section]
            return sectionInfo?.name
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAllWorkouts {
            guard let sectionInfo = fetchedResultsControllerAll.sections?[section] else { return 0 }
            return sectionInfo.numberOfObjects
        }
        // Workout Names
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if isAllWorkouts {
            let workout = fetchedResultsControllerAll.object(at: indexPath)
            let dateString = dateFormatter.string(from: workout.startTime! as Date)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(workout.name!)\n \(dateString)"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        } else {
            let workoutDict = fetchedResultsController.object(at: indexPath)
            cell.textLabel?.text = workoutDict["name"] as? String
            cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
        }
        
        return cell
    }
    
}

// Table View Delegate
extension SummaryViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            guard let sections = fetchedResultsController.sections else {
                return 1
            }
            return sections.count
        }
        
        guard let sections = fetchedResultsControllerAll.sections else {
            return 1
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAllWorkouts == false {
            performSegue(withIdentifier: "ShowExcercises", sender: self)
        } else {
            performSegue(withIdentifier: "ShowWorkoutStats", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(displayP3Red: 100/255, green: 212/255, blue: 255/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    }
    
    func segmentControlValueChanged(segment: UISegmentedControl) {
        
        if segment.selectedSegmentIndex == 0 {
            // Show only types of workouts created
            deleteBarButtonItem.isEnabled = false
            isAllWorkouts = false
            tableView.reloadData()
        }
        
        if segment.selectedSegmentIndex == 1 {
            // Show All Workouts
            deleteBarButtonItem.isEnabled = true
            isAllWorkouts = true
            guard workouts.count == 0 else {
                tableView.reloadData()
                return
            }
            
            fetchAllWorkouts()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // only edit Show All
        if segmentedControl.selectedSegmentIndex == 1 && tableView.isEditing {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard segmentedControl.selectedSegmentIndex == 1 else { return }
        
        let workout = fetchedResultsControllerAll.object(at: indexPath)
        
        managedContext.delete(workout)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error deleting individual workout: \(error.localizedDescription)")
        }
    }
    
}


extension SummaryViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            if indexPath?.row != 0 || tableView.numberOfRows(inSection: indexPath!.section) > 1 {
                tableView.deleteRows(at: [indexPath!], with: .fade)
            } else {
                let indexSet = IndexSet(integer: indexPath!.section)
                tableView.deleteSections(indexSet, with: .fade)
            }
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}






















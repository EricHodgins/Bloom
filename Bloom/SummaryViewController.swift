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
    
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    var managedContext: NSManagedObjectContext!
    var workoutTypes: [NSDictionary] = []
    var workouts: [Workout] = []
    var isAllWorkouts: Bool = false
    
    var dateFormatter: DateFormatter!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
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
    
    func fetchWorkoutTypes() {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "WorkoutTemplate")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(WorkoutTemplate.name), ascending: true)]
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = ["name"]
        
        do {
            workoutTypes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Workout template fetch error: \(error.userInfo)")
        }
    }
    
    func fetchAllWorkouts() {
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Workout.name), ascending: true)]
        
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("All workout fetch error: \(error.userInfo)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExcercises" {
            let excerciseController = segue.destination as! ExcercisesController
            let cellIndex = tableView.indexPathForSelectedRow!
            excerciseController.managedContext = managedContext
            excerciseController.workoutName = workoutTypes[cellIndex.row]["name"] as! String
        }
        
        if segue.identifier == "ShowWorkoutStats" {
            let workoutDetailController = segue.destination as! WorkoutDetailController
            workoutDetailController.workout = workouts[tableView.indexPathForSelectedRow!.row]   
        }
    }
    
    @IBAction func segmentControllPressed(_ sender: UISegmentedControl) {
        segmentControlValueChanged(segment: sender)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if tableView.isEditing {
            deleteBarButtonItem.title = "Delete"
            deleteBarButtonItem.tintColor = UIColor(colorLiteralRed: 255/255, green: 0, blue: 0, alpha: 1.0)
            tableView.setEditing(false, animated: true)
        } else {
            deleteBarButtonItem.title = "Done"
            deleteBarButtonItem.tintColor = UIColor(colorLiteralRed: 61/255, green: 157/255, blue: 148/255, alpha: 1.0)
            tableView.setEditing(true, animated: true)
        }
    }
}

// Table View Delegate
extension SummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAllWorkouts {
            return workouts.count
        }
        return workoutTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if isAllWorkouts {
            let workout = workouts[indexPath.row]
            let dateString = dateFormatter.string(from: workout.startTime! as Date)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(workout.name!)\n \(dateString)"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        } else {
            cell.textLabel?.text = workoutTypes[indexPath.row]["name"] as? String
            cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
        }
        
        return cell
    }
}

// Table View Delegate
extension SummaryViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        cell?.contentView.backgroundColor = UIColor(colorLiteralRed: 100/255, green: 212/255, blue: 255/255, alpha: 1.0)
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
        
        let workout = workouts[indexPath.row]
        tableView.beginUpdates()
        workouts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
        managedContext.delete(workout)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error deleting individual workout: \(error.localizedDescription)")
        }
    }
}

























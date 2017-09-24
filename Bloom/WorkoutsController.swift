//
//  WorkoutsController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-25.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class WorkoutsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    var managedContext: NSManagedObjectContext!
    var workouts = [WorkoutTemplate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchWorkouts()
        authorizeHealthKit()
    }
    
    func authorizeHealthKit() {
        let healthService:HealthDataService = HealthDataService()
        healthService.authorizeHealthKitAccess {(accessGranted, error) in
            DispatchQueue.main.async {
                if accessGranted {
                    print("Access granted to HealthKit Store.")
                } else {
                    print("HealthKit authorization denied! \n\(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    func fetchWorkouts() {
        let fetchRequest = NSFetchRequest<WorkoutTemplate>(entityName: "WorkoutTemplate")
        
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Save error: \(error), description: \(error.userInfo)")
        }
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

extension WorkoutsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let workout = workouts[indexPath.row]
        cell.textLabel?.text = workout.name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
        
        return cell
    }
    
}

extension WorkoutsController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartWorkoutSegue" {
            let workoutCellIndex = tableView.indexPathForSelectedRow!
            let workoutTemplate = workouts[workoutCellIndex.row]
            let startWorkoutController = segue.destination as! StartWorkoutController
            
            startWorkoutController.workoutName = workoutTemplate.name
            startWorkoutController.workoutTemplate = workoutTemplate
            startWorkoutController.managedContext = managedContext
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(displayP3Red: 252/255, green: 123/255, blue: 151/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let workout = workouts[indexPath.row]
        tableView.beginUpdates()
        workouts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
        managedContext.delete(workout)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error deleting WorkoutTEmplate: \(error.localizedDescription)")
        }
        
    }
}













































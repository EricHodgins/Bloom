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
    
    var managedContext: NSManagedObjectContext!
    var workouts = [WorkoutTemplate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchWorkouts()
    }
    
    func fetchWorkouts() {
        let fetchRequest = NSFetchRequest<WorkoutTemplate>(entityName: "WorkoutTemplate")
        
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Save error: \(error), description: \(error.userInfo)")
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
        
        return cell
    }
    
}

extension WorkoutsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Setup in the storyboard
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartWorkoutSegue" {
            let workoutCellIndex = tableView.indexPathForSelectedRow!
            let workoutTemplate = workouts[workoutCellIndex.row]
            let startWorkoutController = segue.destination as! StartWorkoutController

            startWorkoutController.workout = createNewWorkout(workoutTemplate: workoutTemplate)
            startWorkoutController.managedContext = managedContext
        }
    }
    
    func createNewWorkout(workoutTemplate: WorkoutTemplate) -> Workout {
        let workout = Workout(context: managedContext)
        workout.name = workoutTemplate.name
        
        for excerciseTemplate in workoutTemplate.excercises! {
            let excercise = Excercise(context: managedContext)
            excercise.name = (excerciseTemplate as! ExcerciseTemplate).name!
            workout.addToExcercises(excercise)
        }
        
        return workout
    }
}















































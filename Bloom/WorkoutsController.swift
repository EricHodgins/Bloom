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
    var workouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        fetchWorkouts()
    }
    
    func fetchWorkouts() {
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        
        do {
            workouts = try managedContext.fetch(fetchRequest)
            testData(workouts: workouts)
        } catch let error as NSError {
            print("Save error: \(error), description: \(error.userInfo)")
        }
    }
    
    func testData(workouts: [Workout]) {
        for workout in workouts {
            print(workout.name! as String)
            for e in workout.excercises! {
                let excer = e as! Excercise
                print(excer.name! as String)
            }
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















































//
//  WorkoutDetailController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class WorkoutDetailController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var workout: Workout!
    var excercises: [Excercise] = []
    
    var dateFormatter: DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        
        excercises = workout.excercises?.sorted(by: { (e1, e2) -> Bool in
            return (e1 as! Excercise).orderNumber < (e2 as! Excercise).orderNumber
        }) as! [Excercise]
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension WorkoutDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return excercises.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutInfoCell", for: indexPath) as! WorkoutTableCell
            cell.workoutDate.text = "\(dateFormatter.string(from: workout.startTime! as Date))"
            cell.workoutName.text = "\(workout.name!)"
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExcerciseCell", for: indexPath) as! ExcerciseTableCell
        let excercise = excercises[indexPath.row - 1]
        cell.excerciseName.text = "\(excercise.name!)"
        cell.repsLabel.text = "Reps: \(excercise.reps)"
        cell.weightLabel.text = "Weight: \(excercise.weight) lbs"
        cell.distanceLabel.text = "Distance: \(excercise.distance) Km"
        
        return cell
    }
    
}

extension WorkoutDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.bounds.height * 0.25
        }
        return view.bounds.height * 0.333
    }
}

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
        
        queryHeartRateDataFromHealthStore()
    }
    
    func queryHeartRateDataFromHealthStore() {
        let healthService = HealthDataService()
        healthService.queryHeartRateData(withStartDate: workout.startTime! as Date, toEndDate: workout.endTime! as Date)
    }

}

extension WorkoutDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return excercises.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Header
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutInfoCell", for: indexPath) as! WorkoutTableCell
            cell.workoutDate.text = "\(dateFormatter.string(from: workout.startTime! as Date))"
            cell.workoutName.text = "\(workout.name!)"
            cell.workoutDuration.text = workout.startTime!.delta(to: workout.endTime!)
            
            return cell
        }
        
        // Excercise Details
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExcerciseCell", for: indexPath) as! ExcerciseTableCell
        let excercise = excercises[indexPath.row - 1]
        cell.excerciseName.text = "\(excercise.name!)"
        cell.repsLabel.text = "Reps: \(excercise.reps)"
        cell.weightLabel.text = "Weight: \(excercise.weight) lbs"
        cell.distanceLabel.text = "Distance: \(excercise.distance) Km"
        cell.timeLabel.text = workout.startTime!.delta(to: excercise.timeRecorded!)
        
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


// MARK: - Date Extension
extension NSDate {
    public func delta(to: NSDate) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        
        let difference = Calendar.current.dateComponents(dayHourMinuteSecond, from: self as Date, to: to as Date)
        
        let seconds = String(format: "%02d", difference.second!)
        let minutes = String(format: "%02d", difference.minute!)
        let hours = String(format: "%02d", difference.hour!)
        
        return hours + ":" + minutes + ":" + seconds
    }
}



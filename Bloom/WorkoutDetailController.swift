//
//  WorkoutDetailController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class WorkoutDetailController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heartContainerView: UIView!
    
    @IBOutlet weak var heartMapStackView: UIStackView!
    var workout: Workout!
    var managedContext: NSManagedObjectContext!
    var excercises: [Excercise] = []
    
    @IBOutlet weak var durationLabel: UILabel!
    var dateFormatter: DateFormatter!
    
    var sections: [String] = []
    var rows: [[String]] = [[]]
    
    let userDefaults = UserDefaults.standard
    var weightMetric: String = "kg"
    var distanceMetric: String = "km"
    let formatter = MeasurementFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = workout.name!

        setupHeartBeat()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        
        excercises = workout.excercises?.sorted(by: { (e1, e2) -> Bool in
            return (e1 as! Excercise).orderNumber < (e2 as! Excercise).orderNumber
        }) as! [Excercise]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        durationLabel.text = workout.startTime?.delta(to: workout.endTime!)
        
        setupExcerciseTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func setupExcerciseTableData() {
        formatter.unitOptions = .providedUnit
        weightMetric = Metric.weightMetricString()
        distanceMetric = Metric.distanceMetricString()
        
        sections = excercises.map({ (excercise) -> String in
            return excercise.name!
        })
        
        rows = excercises.map({ (excercise) -> [String] in
            var data: [String] = []
            if excercise.sets != 0 { data.append("Sets: \(excercise.sets)")}
            if excercise.reps != 0 { data.append("Reps: \(excercise.reps)") }
            if excercise.weight != 0 { data.append("Weight: \(excercise.weight) \(weightMetric)") }
            if excercise.distance != 0 { data.append("Distance: \(excercise.distance) \(distanceMetric)") }
            
            return data
        })
    }
    
    func setupHeartBeat() {
        let size = heartContainerView.frame.width
        let heartView = HeartView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        heartContainerView.addSubview(heartView)
        heartView.pulse(speed: .slow)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HeartRateSegue" {
            let controller = segue.destination as! HeartBeatGraphController
            controller.workout = workout
        }
        
        if segue.identifier == "RecordedMap" {
            let controller = segue.destination as! MapRouteDetailController
            controller.workout = workout
            controller.managedContext = managedContext
        }
    }

}

extension WorkoutDetailController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Excercise Details
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExcerciseCell", for: indexPath)
        configureExcerciseCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func configureExcerciseCell(cell: UITableViewCell, indexPath: IndexPath) {
        let excerciseMetric = rows[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = excerciseMetric
        cell.textLabel?.textColor = UIColor.white
    }
    
}

extension WorkoutDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        header.textLabel?.font = UIFont.systemFont(ofSize: 20)
    }
}





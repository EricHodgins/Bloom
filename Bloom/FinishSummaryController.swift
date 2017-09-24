//
//  FinishSummaryController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-04.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import SpriteKit

class FinishSummaryController: UIViewController {
    
    lazy var scene: FinishScene! = {
        return FinishScene(size: self.view.frame.size)
    }()

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var highBPMLabel: UILabel!
    @IBOutlet weak var lowBPMLabel: UILabel!
    @IBOutlet weak var avgBPMLabel: UILabel!
    
    var workout: Workout!
    var excercises: [Excercise]!
    @IBOutlet weak var tableView: UITableView!
    
    var sections: [String] = []
    var rows: [[String]] = [[]]
    
    let userDefaults = UserDefaults.standard
    var weightMetric: String = "kg"
    var distanceMetric: String = "km"
    let formatter = MeasurementFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.unitOptions = .providedUnit
        if let selectedWeight = userDefaults.value(forKey: "WeightUnit") as? String,
            selectedWeight == "lbs" {
            weightMetric = selectedWeight
        }
        
        if let selectedDistance = userDefaults.value(forKey: "DistanceUnit") as? String,
            selectedDistance == "mi" {
            distanceMetric = selectedDistance
        }
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.boldSystemFont(ofSize: 20)
    
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.backgroundColor = UIColor.clear
        skView.presentScene(scene)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = nil
        
        workoutDetailsDisplay()
        setupExcerciseData()
    }
    
    private func setupExcerciseData() {
        guard workout != nil,
            workout.excercises != nil else { return }
        
        excercises = workout.excercises?.sorted(by: { (e1, e2) -> Bool in
            return (e1 as! Excercise).orderNumber < (e2 as! Excercise).orderNumber
        }) as! [Excercise]
        
        sections = excercises.map({ (excercise) -> String in
            return excercise.name!
        })
        
        rows = excercises.map({ (excercise) -> [String] in
            var data: [String] = []
            if excercise.sets != 0 { data.append("Sets: \(excercise.sets)") }
            if excercise.reps != 0 { data.append("Reps: \(excercise.reps)") }
            if excercise.weight != 0 {
                let weightKg = Measurement(value: excercise.weight, unit: UnitMass.kilograms)
                if weightMetric == "lbs" {
                    let weightPounds = weightKg.converted(to: UnitMass.pounds)
                    data.append("Weight: \(formatter.string(from: weightPounds))s")
                } else {
                    data.append("Weight: \(formatter.string(from: weightKg))")
                }
            }
            if excercise.distance != 0 {
                let distanceKm = Measurement(value: excercise.distance, unit: UnitLength.kilometers)
                if distanceMetric == "mi" {
                    let distanceMi = distanceKm.converted(to: UnitLength.miles)
                    data.append("Distance: \(formatter.string(from: distanceMi))")
                } else {
                    data.append("Distance: \(formatter.string(from: distanceKm))")
                }
            }
            
            return data
        })
    }

    private func workoutDetailsDisplay() {
        guard workout != nil else { return }
        let summarizer = WorkoutSummary(workout: workout)
        summarizer.delegate = self
        
        if let name = workout.name {
            workoutNameLabel.text = name
        }
        
        if let duration = summarizer.durationString() {
            durationLabel.text = duration
        }
    }
    
    
    @IBAction func dismissPressed(_ sender: Any) {
        scene.removeFlareAction()
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
}

extension FinishSummaryController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let excerciseMetric = rows[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = excerciseMetric
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
}

extension FinishSummaryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(displayP3Red: 4/255, green: 132/255, blue: 255/255, alpha: 1.0)
        
    }
}

extension FinishSummaryController: WorkoutSummarizer {
    func maxBPM(bpm: Double?) {
        if let max = bpm {
            highBPMLabel.text = "High: \(max) BPM"
        }
    }
    
    func minBPM(bpm: Double?) {
        if let min = bpm {
            lowBPMLabel.text = "Low: \(min) BPM"
        }
    }
    
    func avgBPM(bpm: Double?) {
        if let avg = bpm {
            let formattedAvgString = String(format: "%.0f", avg)
            avgBPMLabel.text = "Avg: \(formattedAvgString) BPM"
        }
    }
    
    func totalDistance(inMetres metres: Measurement<UnitLength>) {
        
    }
}






















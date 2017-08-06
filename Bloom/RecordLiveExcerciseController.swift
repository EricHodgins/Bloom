//
//  RecordLiveExcerciseController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-07.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class RecordLiveExcerciseController: UIViewController {
    
    var workoutSession: WorkoutSessionManager!
    var managedContext: NSManagedObjectContext!
    var fetchRequest: NSFetchRequest<NSDictionary>!
    var bloomFilter: BloomFilter!
    
    var workoutName: String!
    
    var maxReps: Double?
    var maxWeight: Double?
    
    weak var excerciseLabel: UILabel!
    var currentCounter: Double = 0.0 // keeps track of the textfield in RecordLiveStatView to increase/decrease values
    
    var recordLiveStatView: RecordLiveStatView!
    var blurEffectView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        excerciseLabel.text = workoutSession.currentExcercise.name!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        maxReps = fetchMaxReps()
        maxWeight = fetchMaxWeight()
    }
    
    func fetchMaxReps() -> Double {
        bloomFilter = BloomFilter()
        return bloomFilter.fetchMaxReps(forExcercise: workoutSession.currentExcercise.name!, inWorkout: workoutSession.workout.name!, withManagedContext: managedContext)
    }
    
    func fetchMaxWeight() -> Double {
        bloomFilter = BloomFilter()
        return bloomFilter.fetchMaxWeight(forExcercise: workoutSession.currentExcercise.name!, inWorkout: workoutSession.workout.name!, withManagedContext: managedContext)
    }
    
    @IBAction func nextExcerciseTapped(_ sender: Any) {
        DispatchQueue.main.async {
            
            if self.workoutSession.currentExcercise.timeRecorded == nil {
                self.workoutSession.currentExcercise.timeRecorded = NSDate()
            }
            
            _ = self.workoutSession.nextExcercise()
            self.excerciseLabel.text = self.workoutSession.currentExcercise.name!
            self.maxReps = self.fetchMaxReps()
            self.maxWeight = self.fetchMaxWeight()
        }
    }
    
    @IBAction func repsButtonPushed(_ sender: Any) {
        addBlurEffect()
        showRecordView(withTitle: "Reps", andStat: Stat.Reps)
    }
    
    @IBAction func weightsButtonPushed(_ sender: Any) {
        addBlurEffect()
        showRecordView(withTitle: "Weight", andStat: Stat.Weight)
    }
    
    @IBAction func distanceButtonPushed(_ sender: Any) {
        addBlurEffect()
        showRecordView(withTitle: "Distance", andStat: Stat.Distance)
    }
    
    @IBAction func timeButtonPushed(_ sender: Any) {
        addBlurEffect()
        showRecordView(withTitle: "Time", andStat: Stat.Time)
    }
    
    func showRecordView(withTitle title: String, andStat stat: Stat) {
        retriveCurrentExcerciseValue(excercise: workoutSession.currentExcercise) // debug code
        
        let text: String
        switch stat {
        case .Reps:
            text = "\(maxReps ?? 0)"
            currentCounter = maxReps ?? 0
        case .Weight:
            text = "\(maxWeight ?? 0)"
            currentCounter = maxWeight ?? 0
        case .Distance:
            text = "Still need to complete distance values"
            currentCounter = 0.0
        case .Time:
            text = "00:00:00"
        }
        
        
        recordLiveStatView = RecordLiveStatView(inView: view)
        recordLiveStatView.stat = stat
        recordLiveStatView.title.text = title
        recordLiveStatView.textField.text = text

        recordLiveStatView.plusButton.addTarget(self, action: #selector(RecordLiveExcerciseController.plusButtonPushed(sender:)), for: .touchUpInside)
        recordLiveStatView.minusButton.addTarget(self, action: #selector(RecordLiveExcerciseController.minusButtonPushed(sender:)), for: .touchUpInside)
        recordLiveStatView.saveButton.addTarget(recordLiveStatView, action: #selector(RecordLiveStatView.savePressed), for: .touchUpInside)
        recordLiveStatView.cancelButton.addTarget(recordLiveStatView, action: #selector(RecordLiveStatView.cancelPressed), for: .touchUpInside)
        
        recordLiveStatView.completionHandler = { (excerciseValue) in
            
            if let value = excerciseValue {
                self.saveExcerciseValue(forStat: self.recordLiveStatView.stat!, value: value)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffectView.alpha = 0
            }, completion: {_ in
                self.blurEffectView.removeFromSuperview()
            })
            
        }
        
        view.addSubview(recordLiveStatView)
    }
    
    func retriveCurrentExcerciseValue(excercise: Excercise) {
        print("\(String(describing: excercise.name)), Reps: \(excercise.reps), Weight: \(excercise.weight)")
    }
    
    func saveExcerciseValue(forStat stat: Stat, value: String) {
        guard let excercise = workoutSession.currentExcercise else { return }
        
        switch stat {
        case .Reps:
            excercise.reps = Double(value)!
            saveContext()
        case .Weight:
            excercise.weight = Double(value)!
            saveContext()
        case .Distance:
            excercise.distance = Double(value)!
            saveContext()
        case .Time:
            excercise.timeRecorded = NSDate()
        }
    }
    
    func saveContext() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("save error: \(error), description: \(error.userInfo)")
        }
    }
    
    func plusButtonPushed(sender: UIButton) {
        currentCounter += 1.0
        recordLiveStatView.textField.text = "\(currentCounter)"
    }
    
    func minusButtonPushed(sender: UIButton) {
        currentCounter -= 1.0
        recordLiveStatView.textField.text = "\(currentCounter)"
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}






























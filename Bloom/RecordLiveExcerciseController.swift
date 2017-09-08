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
    
    @IBOutlet weak var repsButton: GenericBloomButton!
    @IBOutlet weak var weightButton: GenericBloomButton!
    @IBOutlet weak var distaneButton: GenericBloomButton!
    @IBOutlet weak var timeButton: GenericBloomButton!
    @IBOutlet weak var setsButton: GenericBloomButton!
    
    var workoutSession: WorkoutSessionManager!
    var managedContext: NSManagedObjectContext!
    var fetchRequest: NSFetchRequest<NSDictionary>!
    var bloomFilter: BloomFilter!
    
    var workoutName: String!
    
    var previousWorkout: Workout?
    var maxReps: Double?
    var maxWeight: Double?
    
    weak var excerciseLabel: UILabel!
    var currentCounter: Double = 0.0 // keeps track of the textfield in RecordLiveStatView to increase/decrease values
    
    var recordLiveStatView: RecordLiveStatView!
    var blurEffectView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setsButton.titleLabel?.lineBreakMode = .byWordWrapping
        repsButton.titleLabel?.lineBreakMode = .byWordWrapping
        weightButton.titleLabel?.lineBreakMode = .byWordWrapping
        distaneButton.titleLabel?.lineBreakMode = .byWordWrapping
        timeButton.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        excerciseLabel.text = workoutSession.currentExcercise.name!
        previousWorkout = BloomFilter.fetchPrevious(workout: workoutSession.workout, inManagedContext: managedContext)
        configureButtonsUI(forExercise: workoutSession.currentExcercise, previousWorkout: previousWorkout)
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
            self.configureButtonsUI(forExercise: self.workoutSession.currentExcercise, previousWorkout: self.previousWorkout)
            self.maxReps = self.fetchMaxReps()
            self.maxWeight = self.fetchMaxWeight()
        }
    }
    
    func configureButtonsUI(forExercise exercise: Excercise, previousWorkout: Workout?) {
        let previousExcercise = previousWorkoutExcercise(matchingName: exercise.name)
        
        // Sets
        if exercise.isRecordingSets {
            let sets: Double
            if workoutSession.currentExcercise.sets == 0 {
                sets =  previousExcercise?.sets ?? 0
            } else {
                sets = workoutSession.currentExcercise.sets
            }
            setsButton.isHidden = false
            setsButton.setTitle("Sets\n\(sets)", for: .normal)
            workoutSession.currentExcercise.sets = sets
        } else {
            setsButton.isHidden = true
        }
        
        // Reps
        if exercise.isRecordingReps {
            let reps: Double
            if workoutSession.currentExcercise.reps == 0 {
                reps = previousExcercise?.reps ?? 0
            } else {
                reps = workoutSession.currentExcercise.reps
            }
            repsButton.isHidden = false
            repsButton.setTitle("Reps\n\(reps)", for: .normal)
            workoutSession.currentExcercise.reps = reps
        } else {
            repsButton.isHidden = true
        }
        
        // Weight
        if exercise.isRecordingWeight {
            let weight: Double
            if workoutSession.currentExcercise.weight == 0 {
                weight = previousExcercise?.weight ?? 0
            } else {
                weight = workoutSession.currentExcercise.weight
            }
            weightButton.isHidden = false
            weightButton.setTitle("Weight\n\(weight)", for: .normal)
            workoutSession.currentExcercise.weight = weight
        } else {
            weightButton.isHidden = true
        }
        
        // Distance
        if exercise.isRecordingDistance {
            let distance: Double
            if workoutSession.currentExcercise.distance == 0 {
                distance = previousExcercise?.distance ?? 0
            } else {
                distance = workoutSession.currentExcercise.distance
            }
            distaneButton.isHidden = false
            distaneButton.setTitle("Distance\n\(distance)", for: .normal)
            workoutSession.currentExcercise.distance = distance
        } else {
            distaneButton.isHidden = true
        }
        
        // Time
        if let buttonTime = workoutSession.currentExcercise.timeRecorded {
            let formattedTime = workoutSession.workout.startTime?.delta(to: buttonTime)
            timeButton.setTitle("Time\n\(formattedTime ?? "Error")", for: .normal)
        } else {
            timeButton.setTitle("Time", for: .normal)
        }
    }
    
    private func previousWorkoutExcercise(matchingName: String?) -> Excercise? {
        guard matchingName != nil else { return nil }
        guard let previous = previousWorkout else { return nil }
        guard let excerciseSet = previous.excercises,
            excerciseSet.count > 0 else { return nil }
        
        let excercises = Array(excerciseSet) as! [Excercise]
        for excercise in excercises {
            if excercise.name == matchingName { return excercise }
        }
        
        return nil
    }
    
    @IBAction func setsButtonPushed(_ sender: Any) {
        addBlurEffect()
        showRecordView(withTitle: "Sets", andStat: Stat.Sets)
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
        showRecordView(withTitle: "Time", andStat: Stat.Time)
    }
    
    func showRecordView(withTitle title: String, andStat stat: Stat) {
        retriveCurrentExcerciseValue(excercise: workoutSession.currentExcercise) // debug code remove later
        let previousExcercise = previousWorkoutExcercise(matchingName: workoutSession.currentExcercise.name)
        
        let text: String
        switch stat {
        case .Sets:
            currentCounter = previousExcercise?.sets ?? 0
            text = "\(previousExcercise?.sets ?? 0)"
        case .Reps:
            text = "\(previousExcercise?.reps ?? 0)"
            currentCounter = previousExcercise?.reps ?? 0
        case .Weight:
            text = "\(previousExcercise?.weight ?? 0)"
            currentCounter = previousExcercise?.weight ?? 0
        case .Distance:
            text = "\(previousExcercise?.distance ?? 0)"
            currentCounter = previousExcercise?.distance ?? 0
        case .Time:
            let formattedTime = workoutSession.workout.startTime?.delta(to: NSDate())
            timeButton.setTitle("Time\n\(formattedTime ?? "Error")", for: .normal)
            workoutSession.currentExcercise.timeRecorded = NSDate()
            return
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
                DispatchQueue.main.async {
                    self.configureButtonsUI(forExercise: self.workoutSession.currentExcercise, previousWorkout: self.previousWorkout)
                }
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
        case .Sets:
            excercise.sets = Double(value)!
        case .Reps:
            excercise.reps = Double(value)!
        case .Weight:
            excercise.weight = Double(value)!
        case .Distance:
            excercise.distance = Double(value)!
        case .Time:
            excercise.timeRecorded = NSDate()
        }
        saveContext()
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






























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
    var userDefaults = UserDefaults.standard
    let formatter = MeasurementFormatter()
    var weightMetric: String = "kg"
    var distanceMetric: String = "km"
    var maxReps: Double?
    var maxWeight: Double?
    
    weak var excerciseLabel: UILabel!
    var currentCounter: Double = 0.0 // keeps track of the textfield in RecordLiveStatView to increase/decrease values
    
    var recordLiveStatView: RecordLiveStatView!
    var blurEffectView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let weightUnit = userDefaults.value(forKey: "WeightUnit") as? String,
            weightUnit == "lbs" {
            self.weightMetric = weightUnit
        }
        
        if let distanceUnit = userDefaults.value(forKey: "DistanceUnit") as? String,
            distanceUnit == "mi" {
            self.distanceMetric = "mi"
        }
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
    }
    
    func provideCurrentExcerciseValuesToWatch(completion: ((_ sets: String, _ reps: String, _ weight: String, _ distance: String) -> Void)?) {
        guard let complete = completion else { return }
        let sets = "\(self.workoutSession.currentExcercise.sets)"
        let reps = "\(self.workoutSession.currentExcercise.reps)"
        
        var weight: String
        if self.weightMetric == "lbs" {
            let kg = Measurement(value: self.workoutSession.currentExcercise.weight, unit: UnitMass.kilograms)
            let pounds = kg.converted(to: UnitMass.pounds)
            weight = "\(pounds.value) \(self.weightMetric)"
        } else {
            weight = "\(self.workoutSession.currentExcercise.weight) \(self.weightMetric)"
        }
        
        var distance: String
        if self.distanceMetric == "mi" {
            let km = Measurement(value: self.workoutSession.currentExcercise.distance, unit: UnitLength.kilometers)
            let mi = km.converted(to: UnitLength.miles)
            distance = "\(mi.value) \(self.distanceMetric)"
        } else {
            distance = "\(self.workoutSession.currentExcercise.distance) \(self.distanceMetric)"
        }
        complete(sets, reps, weight, distance)
    }
    
    func nextExcercise(_ sender: Any, completion: ((_ sets: String, _ reps: String, _ weight: String, _ distance: String) -> Void)?) {
        DispatchQueue.main.async {
            
            if self.workoutSession.currentExcercise.timeRecorded == nil {
                self.workoutSession.currentExcercise.timeRecorded = Date()
            }
            
            _ = self.workoutSession.nextExcercise()
            self.excerciseLabel.text = self.workoutSession.currentExcercise.name!
            self.configureButtonsUI(forExercise: self.workoutSession.currentExcercise, previousWorkout: self.previousWorkout)
            if let complete = completion {
                self.provideCurrentExcerciseValuesToWatch(completion: complete)
//                let sets = "\(self.workoutSession.currentExcercise.sets)"
//                let reps = "\(self.workoutSession.currentExcercise.reps)"
//                
//                var weight: String
//                if self.weightMetric == "lbs" {
//                    let kg = Measurement(value: self.workoutSession.currentExcercise.weight, unit: UnitMass.kilograms)
//                    let pounds = kg.converted(to: UnitMass.pounds)
//                    weight = "\(pounds.value) \(self.weightMetric)"
//                } else {
//                    weight = "\(self.workoutSession.currentExcercise.weight) \(self.weightMetric)"
//                }
//                
//                var distance: String
//                if self.distanceMetric == "mi" {
//                    let km = Measurement(value: self.workoutSession.currentExcercise.distance, unit: UnitLength.kilometers)
//                    let mi = km.converted(to: UnitLength.miles)
//                    distance = "\(mi.value) \(self.distanceMetric)"
//                } else {
//                    distance = "\(self.workoutSession.currentExcercise.distance) \(self.distanceMetric)"
//                }
//                complete(sets, reps, weight, distance)
            }
        }
    }
    
    @IBAction func nextExcerciseTapped(_ sender: Any) {
        nextExcercise(sender, completion: nil)
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
            
            var selectedLocale = Measurement(value: weight, unit: UnitMass.kilograms)
            
            if weightMetric == "lbs" {
                selectedLocale = selectedLocale.converted(to: UnitMass.pounds)
            }
            
            weightButton.isHidden = false
            weightButton.setTitle("Weight\n\(selectedLocale.value) \(weightMetric)", for: .normal)
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
            
            var selectedLocale = Measurement(value: distance, unit: UnitLength.kilometers)
            
            if distanceMetric == "mi" {
                selectedLocale = selectedLocale.converted(to: UnitLength.miles)
            }
            
            distaneButton.isHidden = false
            distaneButton.setTitle("Distance\n\(selectedLocale.value) \(distanceMetric)", for: .normal)
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
            let wt = previousExcercise?.weight ?? 0
            var selectedLocale = Measurement(value: wt, unit: UnitMass.kilograms)
            
            if weightMetric == "lbs" {
                selectedLocale = selectedLocale.converted(to: UnitMass.pounds)
            }
            text = "\(selectedLocale.value)"
            currentCounter = selectedLocale.value
        case .Distance:
            let distance = previousExcercise?.distance ?? 0
            var selectedLocale = Measurement(value: distance, unit: UnitLength.kilometers)
            
            if distanceMetric == "mi" {
                selectedLocale = selectedLocale.converted(to: UnitLength.miles)
            }
            text = "\(selectedLocale.value)"
            currentCounter = selectedLocale.value
        case .Time:
            let formattedTime = workoutSession.workout.startTime?.delta(to: Date())
            timeButton.setTitle("Time\n\(formattedTime ?? "Error")", for: .normal)
            workoutSession.currentExcercise.timeRecorded = Date()
            return
        }
        
        
        recordLiveStatView = RecordLiveStatView(inView: view)
        BloomTextfieldManager.shared.viewToMove = recordLiveStatView
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
            if weightMetric == "lbs" {
                let valueInPounds = Measurement(value: Double(value)!, unit: UnitMass.pounds)
                let valueToKilograms = valueInPounds.converted(to: UnitMass.kilograms)
                excercise.weight = valueToKilograms.value
            } else {
                // It's already kilograms
                excercise.weight = Double(value)!
            }
        case .Distance:
            if distanceMetric == "mi" {
                let valueInMiles = Measurement(value: Double(value)!, unit: UnitLength.miles)
                let valueToKilometres = valueInMiles.converted(to: UnitLength.kilometers)
                excercise.distance = valueToKilometres.value
            } else {
                // It's alrady Kilometres
                excercise.distance = Double(value)!
            }
        case .Time:
            excercise.timeRecorded = Date()
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
    
    @objc func plusButtonPushed(sender: UIButton) {
        currentCounter += 1.0
        recordLiveStatView.textField.text = "\(currentCounter)"
    }
    
    @objc func minusButtonPushed(sender: UIButton) {
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

extension RecordLiveExcerciseController: MappedDistance {
    // length will come in as Metres
    func updateMappedDistance(formattedValue: String, valueInKm: Measurement<UnitLength>) {
        let length = valueInKm.converted(to: UnitLength.kilometers)
        if distaneButton.isHidden == false {
            workoutSession.currentExcercise.distance = length.value
            DispatchQueue.main.async {
                self.distaneButton.setTitle("Distance\n\(formattedValue)", for: .normal)
            }
        }
    }
}





























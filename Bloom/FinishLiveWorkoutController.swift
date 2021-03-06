//
//  FinishLiveWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-07.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit


class FinishLiveWorkoutController: UIViewController {

    @IBOutlet weak var finishWorkoutButton: GenericBloomButton!
    var workout: Workout!
    
    var workoutSession: WorkoutSessionManager!
    
    @IBOutlet weak var percentCompleteLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = 0.0
        percentCompleteLabel.text = "0.0 % Complete"
    }
    
    deinit {
        print("FINISH LIVE WORKOUT CONTROLLER DEINIT..")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        view.layer.insertSublayer(emitter, below: finishWorkoutButton.layer)
        
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height)
        emitter.emitterSize = rect.size
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "spark.png")?.cgImage
        
        emitterCell.birthRate = 10
        emitterCell.lifetime = 50.0
        emitter.emitterCells = [emitterCell]
        emitterCell.yAcceleration = -4.0
        emitterCell.scale = 0.07
        emitterCell.scaleRange = 0.1
        emitterCell.redRange = 0.3
        emitterCell.greenRange = 0.9
        emitterCell.blueRange  = 0.3
        emitterCell.color = UIColor(red: 243/255, green: 23/255, blue: 0/255, alpha: 1.0).cgColor
    }
    
    @IBAction func finishWorkoutButtonPressed(_ sender: Any) {
        workoutSession.saveMapRoute()
        workout.endTime = Date()
        workoutSession.state = .finished
        do {
            try workout.managedObjectContext?.save()
        } catch let error as NSError {
            print("Save Error at Finish Workout Button: \(error), \(error.userInfo)")
        }
        
        PhoneConnectivityManager.sendFinishedMessage()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.phoneConnectivityManager.liveWorkoutController = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SummarySegue" {
            let summary = segue.destination as! FinishSummaryController
            summary.workout = workout
        }
    }
    
    func segueToMainMenu() {
        performSegue(withIdentifier: "SummarySegue", sender: self)
    }
}

extension FinishLiveWorkoutController: UpdateFinishedProgress {
    func updateProgress() {
        let total = Float(workoutSession.excercises.count)
        var complete: Float = 0.0
        for e in workoutSession.excercises {
            if e.timeRecorded != nil {
                complete += 1
            }
        }
        let percent = Float(complete / total)
        DispatchQueue.main.async {
            self.percentCompleteLabel.text = String(format: "%.1f", percent*100.0) + " % Complete"
            self.progressBar.progress = percent
        }
    }
}
























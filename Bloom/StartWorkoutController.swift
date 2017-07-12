//
//  StartWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-25.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

//CountDown protoco is in the AppDelegate for now
class StartWorkoutController: UIViewController, CountDown {
    
    @IBOutlet weak var startButton: StartButton!
    @IBOutlet weak var editWorkoutButton: EditWorkoutButton!
    @IBOutlet weak var countDownView: CountDownView!
    @IBOutlet weak var countDownLabel: UILabel!
    
    var ringAnimationInterval: Int = 3
    var workoutName: String!
    
    var managedContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = workoutName
        
        startButton.editWorkoutButton = editWorkoutButton
        countDownView.countDownLabel = countDownLabel
        countDownView.isHidden = true
        countDownView.delegate = self
        startButton.buttonAnimationCompletion = {
            self.countDownView.isHidden = false
            self.countDownView.startCountDown(withSeconds: self.ringAnimationInterval)
            self.countDownView.animateRing(withSeconds: self.ringAnimationInterval)
        }
        startButton.addTarget(startButton, action: #selector(StartButton.animateGradient), for: .touchUpInside)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {

    }
}

extension StartWorkoutController {
    func countDownComplete() {
        performSegue(withIdentifier: "LiveWorkoutSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LiveWorkoutSegue" {
            let liveWorkoutController = segue.destination as! LiveWorkoutController
            liveWorkoutController.workoutName = workoutName
            liveWorkoutController.managedContext = managedContext
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.phoneConnectivityManager.liveWorkoutController = liveWorkoutController
        }
    }
}








































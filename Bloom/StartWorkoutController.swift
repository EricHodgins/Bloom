//
//  StartWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-25.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit


class StartWorkoutController: UIViewController {
    
    @IBOutlet weak var startButton: StartButton!
    @IBOutlet weak var editWorkoutButton: EditWorkoutButton!
    @IBOutlet weak var countDownView: CountDownView!
    @IBOutlet weak var countDownLabel: UILabel!
    
    var workout: Workout!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = workout.name
        
        startButton.editWorkoutButton = editWorkoutButton
        countDownView.isHidden = true
        countDownView.countDownLabel = countDownLabel
        startButton.buttonAnimationCompletion = {
            self.countDownView.isHidden = false
            self.countDownView.animateCircleDrawn()
        }
        startButton.addTarget(startButton, action: #selector(StartButton.animateGradient), for: .touchUpInside)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {

    }
}

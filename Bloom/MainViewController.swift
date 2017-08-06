//
//  ViewController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-12.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var createWorkoutButton: CreateWorkoutButton!
    @IBOutlet weak var beginWorkoutButton: BeginWorkoutButton!
    @IBOutlet weak var statsButton: StatsButton!
    
    var managedContext: NSManagedObjectContext!
    var heartView: HeartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        heartView = HeartView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        heartView.frame.origin = CGPoint(x: view.frame.width/2 - 25, y: view.frame.height/2 + 60)
        view.addSubview(heartView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        heartView.pulse(speed: .slow)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        createWorkoutButton.setNeedsDisplay()
        beginWorkoutButton.setNeedsDisplay()
        statsButton.setNeedsDisplay()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateWorkout" {
            let createController = segue.destination as! CreateWorkoutController
            createController.managedContext = managedContext
        }
        
        if segue.identifier == "Workouts" {
            let workoutsController = segue.destination as! WorkoutsController
            workoutsController.managedContext = managedContext
        }
        
        if segue.identifier == "Summary" {
            let summaryController = segue.destination as! SummaryViewController
            summaryController.managedContext = managedContext
        }
    }
    
    // When a workout is complete (Big Finish button is pressed) it navigates to back here
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        navigationController?.navigationBar.isHidden = false
    }
}












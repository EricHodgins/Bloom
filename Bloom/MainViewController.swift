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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    }
}


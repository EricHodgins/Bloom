//
//  ViewController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-12.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var lastWorkoutNameLabel: UILabel!
    @IBOutlet weak var lastWorkoutDuration: UILabel!
    
    lazy var scene: FinishScene! = {
        return FinishScene(size: self.lastWorkoutView.frame.size)
    }()
    @IBOutlet weak var lastWorkoutView: SKView!
    @IBOutlet weak var heartContainerView: UIView!
    
    @IBOutlet weak var createWorkoutButton: CreateWorkoutButton!
    @IBOutlet weak var beginWorkoutButton: BeginWorkoutButton!
    @IBOutlet weak var statsButton: StatsButton!
    
    var managedContext: NSManagedObjectContext!
    var workout: Workout?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeartBeat()
        
        let skView = lastWorkoutView!
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.backgroundColor = UIColor.clear
        skView.presentScene(scene)
        
    }
    
    func setupHeartBeat() {
        let size = heartContainerView.frame.width
        let heartView = HeartView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        heartContainerView.addSubview(heartView)
        heartView.pulse(speed: .slow)
    }
    
    func fetchLastWorkout() {
        workout = BloomFilter.fetchLastWorkout(inManagedContext: managedContext)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        scene.startSunFlareAction()
        fetchLastWorkout()
        fillINLastWorkoutValues()
    }
    
    func fillINLastWorkoutValues() {
        guard let lastWorkout = workout,
         let start = lastWorkout.startTime,
            let end = lastWorkout.endTime else {
                lastWorkoutNameLabel.text = "No workout data."
                lastWorkoutDuration.text = "--"
                return
        }
        
        lastWorkoutNameLabel.text = lastWorkout.name ?? ""
        lastWorkoutDuration.text = start.delta(to: end)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scene.removeFlareAction()
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
        
        if segue.identifier == "LastWorkoutSegue" {
            let lastWorkoutSummaryController = segue.destination as! FinishSummaryController
            lastWorkoutSummaryController.workout = workout
        }
        
        if segue.identifier == "LastMapRouteSegue" {
            let mapRouteDetailController = segue.destination as! MapRouteDetailController
            mapRouteDetailController.workout = workout
        }
        
        if segue.identifier == "LastHeartRateSegue" {
            let heartRateController = segue.destination as! HeartBeatGraphController
            heartRateController.workout = workout
        }
    }
    
    // When a workout is complete (Big Finish button is pressed) it navigates to back here
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        navigationController?.navigationBar.isHidden = false
    }
}












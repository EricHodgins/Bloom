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
         let start = lastWorkout.startTime else {
                lastWorkoutNameLabel.text = "No workout data."
                lastWorkoutDuration.text = "--"
                return
        }
        
        // This check is mostly for when the apple watch hits finish.  One time the endTime was not saved.
        if lastWorkout.endTime == nil {
            lastWorkout.endTime = NSDate()
            do {
             try managedContext.save()
            } catch {
                print("Error saving workout end time when it was not saved originally for some reason.")
            }
        }
        
        let end = lastWorkout.endTime!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        
        let blue = UIColor(colorLiteralRed: 4/255, green: 132/255, blue: 255/255, alpha: 1.0)
        
        lastWorkoutNameLabel.text = lastWorkout.name ?? ""
        lastWorkoutNameLabel.textColor = UIColor.red
        
        
        let dateDurationString = dateFormatter.string(from: start as Date) + " - " + start.delta(to: end)
        let range = NSRange(location: dateDurationString.characters.count - 8, length: 8)
        let coloredString = NSMutableAttributedString(string: dateDurationString, attributes: [:])
        coloredString.addAttribute(NSForegroundColorAttributeName, value: blue, range: range)

        lastWorkoutDuration.attributedText = coloredString
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
            let navController = segue.destination as! UINavigationController
            let createController = navController.topViewController as! CreateController
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












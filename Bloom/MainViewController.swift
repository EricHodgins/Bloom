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
    
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
        
    lazy var scene: FinishScene! = {
        return FinishScene(size: self.sunflareView.frame.size)
    }()
    
    @IBOutlet weak var sunflareView: SKView!
    
    @IBOutlet weak var heartContainerView: UIView!
    
    @IBOutlet weak var createWorkoutButton: CreateWorkoutButton!
    @IBOutlet weak var beginWorkoutButton: BeginWorkoutButton!
    @IBOutlet weak var statsButton: StatsButton!
    
    var managedContext: NSManagedObjectContext!
    var workout: Workout?

    @IBOutlet weak var flower: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont.systemFont(ofSize: 28.0)
        let attributes = [NSAttributedStringKey.font: font]
        settingsBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
        settingsBarButtonItem.title = "\u{2699}\u{0000FE0E}"
        
        let skView = sunflareView!
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.backgroundColor = UIColor.clear
        skView.presentScene(scene)
    }
    
    func fetchLastWorkout() {
        workout = BloomFilter.fetchLastWorkout(inManagedContext: managedContext)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scene.startSunFlareAction()
        setupFlowerImageAnimation()
    }
    
    func setupFlowerImageAnimation() {
        var flowerImages: [UIImage] = []
        for i in 1...38 {
            let flowerImage = UIImage(named: "Flower_\(i).png")!
            flowerImages.append(flowerImage)
        }
        flower.animationImages = flowerImages
        flower.animationDuration = 1.5
        flower.animationRepeatCount = 1
        flower.image = UIImage(named: "LaunchScreen.png")!
        flower.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        flower.image = UIImage(named: "Flower_1.png")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        performSegue(withIdentifier: "LastWorkoutSegue", sender: self)
    }
    
    // When a workout is complete (Big Finish button is pressed) it navigates to back here
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        navigationController?.navigationBar.isHidden = false
    }
}












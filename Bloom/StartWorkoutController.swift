//
//  StartWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-25.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit
import MetalKit

protocol CountDown: class {
    func countDownComplete()
}

protocol UpdateWorkoutList: class {
    func updateWorkoutList()
}

protocol UpdateFinishedProgress: class {
    func updateProgress()
}


class StartWorkoutController: UIViewController, CountDown {
    
    @IBOutlet weak var startButton: StartButton!
    @IBOutlet weak var editWorkoutButton: EditWorkoutButton!
    @IBOutlet weak var countDownView: CountDownView!
    @IBOutlet weak var countDownLabel: UILabel!
    
    var ringAnimationInterval: Int = 3
    var workoutName: String!
    var workoutTemplate: WorkoutTemplate!
    
    var managedContext: NSManagedObjectContext!
    var renderer: Renderer?

    @IBOutlet weak var metalView: MTKView!
    @IBOutlet weak var flower: UIImageView!
    
    lazy var dustParticleScene: SKScene! = {
        var scene: SKScene = DustParticleScene(size: dustParticleView.frame.size)
        scene.backgroundColor = UIColor.clear
        return scene
    }()
    
    @IBOutlet weak var dustParticleView: SKView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = workoutName
        
        startButton.editWorkoutButton = editWorkoutButton
        countDownView.countDownLabel = countDownLabel
        countDownView.isHidden = true
        countDownView.delegate = self
        startButton.buttonAnimationCompletion = { [unowned self] in
            self.countDownView.isHidden = false
            self.countDownView.startCountDown(withSeconds: self.ringAnimationInterval)
            self.countDownView.animateRing(withSeconds: self.ringAnimationInterval)
        }
        startButton.addTarget(startButton, action: #selector(StartButton.animateGradient), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(StartWorkoutController.hideNavigation), for: .touchUpInside)
        
        //Create Cool Metal Shader Scene
        
        metalView.device = MTLCreateSystemDefaultDevice()
        guard let device = metalView.device else {
            fatalError("Metal Device could not be created.")
        }
        
        renderer = Renderer(device: device)
        metalView.delegate = renderer
        
        renderer?.scene = StartWorkoutScene(device: device, size: view.bounds.size)
        dustParticleView.presentScene(dustParticleScene)
    }
    
    deinit {
        print("START CONTROLLER DEINIT..")
    }
    
    @objc func hideNavigation() {
        UIView.animate(withDuration: 0.2) {
            self.flower.alpha = 0.0
        }
        navigationController?.navigationBar.isHidden = true
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFlowerImageAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        flower.image = UIImage(named: "Flower_1.png")
    }
    
    func setupFlowerImageAnimation() {
        var flowerImages: [UIImage] = []
        for i in 1...38 {
            let flowerImage = UIImage(named: "Flower_\(i).png")!
            flowerImages.append(flowerImage)
        }
        flower.animationImages = flowerImages
        flower.animationDuration = 1.0
        flower.animationRepeatCount = 1
        flower.image = UIImage(named: "LaunchScreen.png")!
        flower.startAnimating()
    }
}

extension StartWorkoutController {
    func countDownComplete() {
        performSegue(withIdentifier: "LiveWorkoutSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LiveWorkoutSegue" {
            let liveWorkoutController = segue.destination as! LiveWorkoutController
            liveWorkoutController.workoutSessionManager = WorkoutSessionManager(managedContext: managedContext, workoutName: workoutName, startDate: Date(), deviceInitiated: .phone)
            liveWorkoutController.workoutName = workoutName
            liveWorkoutController.managedContext = managedContext
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.phoneConnectivityManager.liveWorkoutController = liveWorkoutController
        }
        
        if segue.identifier == "EditWorkout" {
            let nav = segue.destination as! UINavigationController
            let editWorkoutController = nav.topViewController as! CreateController
            editWorkoutController.managedContext = managedContext
            editWorkoutController.workout = workoutTemplate
            editWorkoutController.isEditingExistingWorkout = true
        }
    }
}








































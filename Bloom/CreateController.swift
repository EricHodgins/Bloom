//
//  CreateController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-31.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class CreateController: UIViewController {
    var managedContext: NSManagedObjectContext!
    
    var nameWorkoutViewManager: NameWorkoutViewManager!
    var addExcerciseViewManager: AddExcerciseViewManager!
    var findAndCreateViewManager: FindAndCreateViewManager!
    var findViewManager: FindViewManager!
    var createViewManager: CreateViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameWorkoutViewManager = NameWorkoutViewManager(view: self.view)
        nameWorkoutViewManager.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        nameWorkoutViewManager.animateLineSeparator()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.setNeedsDisplay()
    }
}

//MARK: - Name Workout
extension CreateController: NameWorkoutProtocol {
    func cancelPressedFromNameWorkoutView() {
        dismiss(animated: true, completion: nil)
    }
    
    func nextPressedFromNameWorkoutView() {
        print("Next Pressed.")
        addExcerciseViewManager = AddExcerciseViewManager(controller: self)
        addExcerciseViewManager.delegate = self
    }
}

//MARK: - Add Excercise
extension CreateController: AddExcerciseProtocol {
    func addPressedFromAddExcerciseView() {
        findAndCreateViewManager = FindAndCreateViewManager(view: view)
        findAndCreateViewManager.delegate = self
    }
}

//MARK: - Find or Create
extension CreateController: FindAndCreateViewProtocol {
    func findButtonPressed() {
        findViewManager = FindViewManager(controller: self)
        findViewManager.delegate = self
    }
    
    func createButtonPressed() {
        createViewManager = CreateViewManager(controller: self)
        createViewManager.delegate = self
    }
}

//MARK: - Find
extension CreateController: FindViewManagerProtocol {
    func cancelPressedFromFindViewManager() {
        addExcerciseViewManager = AddExcerciseViewManager(controller: self)
        addExcerciseViewManager.delegate = self
    }
    
    func donePressedFromFindViewManager() {
        addExcerciseViewManager = AddExcerciseViewManager(controller: self)
        addExcerciseViewManager.delegate = self
    }
    
}

//MARK: - Create
extension CreateController: CreateViewManagerDelegate {
    func cancelPressedFromCreateView() {
        addExcerciseViewManager = AddExcerciseViewManager(controller: self)
        addExcerciseViewManager.delegate = self
    }
    
    func donePressedFromCreateView() {
        addExcerciseViewManager = AddExcerciseViewManager(controller: self)
        addExcerciseViewManager.delegate = self
    }
}































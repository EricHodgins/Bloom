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


extension CreateController: AddExcerciseProtocol {
    func addPressedFromAddExcerciseView() {
        findAndCreateViewManager = FindAndCreateViewManager(view: view)
        findAndCreateViewManager.delegate = self
    }
}


extension CreateController: FindAndCreateViewProtocol {
    func findButtonPressed() {
        findViewManager = FindViewManager(controller: self)
    }
    
    func createButtonPressed() {
        
    }
}

extension CreateController: FindViewManagerProtocol {
    func cancelPressedFromFindViewManager() {
        print("Cancel pressed.")
    }
    
    func donePressedFromFindViewManager() {
        
    }
    
}

































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
}

extension CreateController: NameWorkoutProtocol {
    func cancelPressedFromNameWorkoutView() {
        dismiss(animated: true, completion: nil)
    }
    
    func nextPressedFromNameWorkoutView() {
        print("Next Pressed.")
    }
}

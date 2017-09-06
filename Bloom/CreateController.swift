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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var nameWorkoutViewManager: NameWorkoutViewManager!
    var addExcerciseViewManager: AddExcerciseViewManager!
    var findAndCreateViewManager: FindAndCreateViewManager!
    var findViewManager: FindViewManager!
    var createViewManager: CreateViewManager!
    
    var currentExcercises: [ExcerciseTemplate] = []
    var workout: WorkoutTemplate?
    var isEditingExistingWorkout: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if workout != nil {
            isEditingExistingWorkout = true
        }
        
        if !isEditingExistingWorkout {
            nameWorkoutViewManager = NameWorkoutViewManager(controller: self)
            nameWorkoutViewManager.delegate = self
        } else {
            guard let excercises = workout?.excercises as? Set<ExcerciseTemplate> else { return }
            let sortedExercises = Array(excercises).sorted(by: { (e1, e2) -> Bool in
                return e1.orderNumber < e2.orderNumber
            })
            currentExcercises = sortedExercises
            addExcerciseViewManager = AddExcerciseViewManager(controller: self)
            addExcerciseViewManager.delegate = self
            saveButton.isEnabled = true
            navigationController?.navigationBar.topItem?.title = workout?.name
        }
    }
    
    // WHen editing a current workout you must retrieve the workout excercises first
    func fetchEditingWorkoutExcercises() {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !isEditingExistingWorkout {
            nameWorkoutViewManager.animateLineSeparator()
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        //At this point you should have a valid workout name in the managedContext
        guard let excercises = addExcerciseViewManager.choosenExcercises() else { return }
        for (index, excerciseTemplate) in excercises.enumerated() {
            excerciseTemplate.orderNumber = Int16(index)
            workout?.addToExcercises(excerciseTemplate)
        }
        
        //save to disk.
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error saving workout: \(error.localizedDescription)")
        }
        
        dismiss(animated: true, completion: nil)    
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        // Set all views to nil to ensure no memory leaks.
        nameWorkoutViewManager = nil
        createViewManager = nil
        addExcerciseViewManager = nil
        findViewManager = nil
        createViewManager = nil
        super.dismiss(animated: flag, completion: nil)
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
    
    func nextPressedFromNameWorkoutView(withName name: String) {
        addExcerciseViewManager = AddExcerciseViewManager(controller: self)
        addExcerciseViewManager.delegate = self
        saveButton.isEnabled = true
    }
}

//MARK: - Add Excercise
extension CreateController: AddExcerciseProtocol {
    func addPressedFromAddExcerciseView() {
        findAndCreateViewManager = FindAndCreateViewManager(view: view)
        findAndCreateViewManager.delegate = self
    }
    
    func cellSelectedToEditFromAddExcerciseView(excercise: ExcerciseTemplate) {
        createViewManager = CreateViewManager(controller: self)
        createViewManager.exerciseTemplate = excercise
        createViewManager.isEditing = true
        createViewManager.delegate = self
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
    
    func donePressedFromFindViewManager(withFoundExcerciseTemplates pickedExcercises: [ExcerciseTemplate]?) {
        if let addedExcercises = pickedExcercises {
            for (index, excercise) in addedExcercises.enumerated() {
                excercise.orderNumber = Int16(currentExcercises.count + index)
            }
            currentExcercises = currentExcercises + addedExcercises
        }
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
    
    func donePressedFromCreateView(withExcerciseTemplate template: ExcerciseTemplate, isEditing: Bool) {
        if isEditing {
            let index = Int(template.orderNumber)
            currentExcercises[index] = template
        } else {
            template.orderNumber = Int16(currentExcercises.count)
            currentExcercises.append(template)
        }
        addExcerciseViewManager = AddExcerciseViewManager(controller: self)
        addExcerciseViewManager.delegate = self
    }
}


//MARK: - Textfield Delegate
extension CreateController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameWorkoutViewManager.textField {
            textField.resignFirstResponder()
            let _ = update(workoutName: textField.text)
        }
        
        if createViewManager != nil {
            if createViewManager.textField.isFirstResponder {
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    //MARK: - Validation
    func update(workoutName: String?) -> Validation {
        let name = workoutName?.removeExtraWhiteSpace
        let validation: Validation = validateWorkout(name: name)
        if validation == .pass {
            if isEditingExistingWorkout {
                changeWorkoutName(name: name!)
            } else {
                createNewWorkout(withName: name!)
            }
            return .pass
        }
        return validation
    }
    
    func validateWorkout(name: String?) -> Validation {
        guard let name = name else { return .isEmpty }
        
        let valid = Validate.workout(name: name, inManagedContext: managedContext)
        switch valid {
        case .isEmpty:
            present(AlertManager.alert(title: "A workout must have a name.", message: "Please name your workout.", style: .alert), animated: true)
            return .isEmpty
        case .alreadyExists:
            present(AlertManager.alert(title: "Workout already exists.", message: "A workout is already named that. Please choose a different name.", style: .alert), animated: true)
            return .alreadyExists
        case .pass:
            return .pass
        case .error:
            present(AlertManager.alert(title: "Something went wrong.", message: "Please try again.", style: .alert), animated: true)
            return .error
        }
    }
    
    func validateExcercise(name: String?) -> Validation {
        let validation = Validate.exercercise(name: name)
        if validation != .pass {
            present(AlertManager.alert(title: "Excercise Name is empty.", message: "Please try again.", style: .alert), animated: true)
        }
        return validation
    }
    
    func createNewWorkout(withName name: String) {
        workout = WorkoutTemplate(context: managedContext)
        workout?.name = name
    }
    
    func changeWorkoutName(name: String) {
        workout?.name = name
    }
}






























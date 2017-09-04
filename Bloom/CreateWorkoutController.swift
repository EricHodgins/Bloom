//
//  CreateWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-17.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class CreateWorkoutController: UIViewController {
    
    @IBOutlet weak var createStackView: UIStackView!
    @IBOutlet weak var findCreateStackView: UIStackView!
    @IBOutlet weak var mainStackViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelStackButton: GenericBloomButton!
    @IBOutlet weak var doneButton: GenericBloomButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var tableViewContainerView: UIView!
    @IBOutlet weak var findButton: GenericBloomButton!
    @IBOutlet weak var createNewExcerciseButton: UIButton!
    
    @IBOutlet weak var numberOfExcercisesLabel: UILabel!
    @IBOutlet weak var enterWorkoutNameContainerView: UIView!
    var excerciseView: AddExcerciseView!

    @IBOutlet weak var addExcerciseButton: UIButton!
    var isAddingExcercise: Bool = false
    @IBOutlet weak var workoutNameTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let lineSeparator: UIView = UIView()
    var blurEffectView: UIVisualEffectView!
    
    var currentWorkout: WorkoutTemplate?
    
    var managedContext: NSManagedObjectContext!
    var workoutName: String? = nil
    var isEditingExistingWorkout: Bool = false
    var excercises: [String] = []
    var existingExcercises: [String] = []
    var selectedRows: [Bool] = []
    var selectedExcercises: [String] = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
        createStackView.isHidden = true
        findCreateStackView.isHidden = true
        findButton.isHidden = true
        createNewExcerciseButton.isHidden = true
        
        cancelStackButton.isHidden = true
        doneButton.isHidden = true
        
        // When Editing a existing workout
        if let name = workoutName {
            workoutNameTextfield.text = name
            fetchWorkoutTemplate(name: name)
        }
        
        fetchAllExistingExcercises()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection =  true
        workoutNameTextfield.delegate = self
    }
    
    // When Editing a current workout
    func fetchWorkoutTemplate(name: String) {
        let workoutFetch: NSFetchRequest<WorkoutTemplate> = WorkoutTemplate.fetchRequest()
        workoutFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(WorkoutTemplate.name), name)
        
        do {
            currentWorkout = try self.managedContext.fetch(workoutFetch).first!
            let excerciseTemplates = (currentWorkout?.excercises?.allObjects as! [ExcerciseTemplate]).sorted(by: { (e1, e2) -> Bool in
                return (e1).orderNumber < (e2).orderNumber
            })
            for excerciseTemplate in excerciseTemplates {
                excercises.append(excerciseTemplate.name!)
            }
            tableView.reloadData()
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
    }
    
    func fetchAllExistingExcercises() {
        let allExecercises = BloomFilter.fetchAllExcercises(inManagedContext: managedContext)
        if let _ = allExecercises {
            //existingExcercises = all
            selectedRows = Array(repeating: false, count: existingExcercises.count)
            selectedExcercises = Array(repeating: "", count: existingExcercises.count)
        }
    }

    @IBAction func segmentControllPressed(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 1 {
            tableView.isEditing = false
            selectedRows = Array(repeating: false, count: existingExcercises.count)
            selectedExcercises = Array(repeating: "", count: existingExcercises.count)
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            tableView.isEditing = true
            for name in selectedExcercises {
                if name != "" {
                    excercises.append(name)
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func workoutNameNextButtonPressed(_ sender: Any) {
        if isCheckedAndTrimmedWorkoutNamePassed() {
            removeWorkoutNameContainerView()
        }
        
        if workoutNameTextfield.isFirstResponder {
            workoutNameTextfield.resignFirstResponder()
        }
    }
    
    fileprivate func removeWorkoutNameContainerView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.enterWorkoutNameContainerView.alpha = 0
        }) { (isFinished) in
            self.enterWorkoutNameContainerView.isHidden = true
            self.lineSeparator.removeFromSuperview()
        }
    }
    
    @IBAction func workoutNameCanceButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Cancel Stack Button Pressed
    @IBAction func cancelStackButtonPressed(_ sender: Any) {
        isAddingExcercise = false
        self.createStackView.isHidden = true
        UIView.animate(withDuration: 0.1) {
            self.cancelStackButton.isHidden = true
            self.doneButton.isHidden = true
            self.numberOfExcercisesLabel.isHidden = false
            self.addExcerciseButton.isHidden = false
            self.saveButton.isEnabled = true
        }
        tableView.reloadData()
        tableView.isEditing = true
    }
    
    //MARK: - Cancel Pressed
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Save Pressed
    @IBAction func savePressed(_ sender: Any) {
        
        guard currentWorkout != nil else {
            let _ = isCheckedAndTrimmedWorkoutNamePassed()
            saveWorkoutAndDismissController()
            return
        }
        
        saveWorkoutAndDismissController()
    }
    
    //MARK: - Done Pressed
    @IBAction func donePressed(_ sender: Any) {
        isAddingExcercise = false
        UIView.animate(withDuration: 0.1) {
            self.cancelStackButton.isHidden = true
            self.doneButton.isHidden = true
            self.addExcerciseButton.isHidden = false
            self.numberOfExcercisesLabel.isHidden = false
            self.saveButton.isEnabled = true
        }
        
        tableView.isEditing = true
        for name in selectedExcercises {
            if name != "" {
                excercises.append(name)
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Find Pressed
    @IBAction func findButtonPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.0) {
            self.findCreateStackView.isHidden = true
            self.findButton.isHidden = true
            self.createNewExcerciseButton.isHidden = true
        }
        
        UIView.animate(withDuration: 0.1) {
            self.tableViewContainerView.alpha = 1
            self.cancelStackButton.isHidden = false
            self.doneButton.isHidden = false
        }
        
        isAddingExcercise = true
        tableView.isEditing = false
        selectedRows = Array(repeating: false, count: existingExcercises.count)
        selectedExcercises = Array(repeating: "", count: existingExcercises.count)
        tableView.reloadData()
    }
    
    //MARK: - Create New Excercise
    @IBAction func createNewExcerciseButtonPressed(_ sender: Any) {
        findCreateStackView.isHidden = true
        findButton.isHidden = true
        createNewExcerciseButton.isHidden = true
        createStackView.isHidden = false
        UIView.animate(withDuration: 0.1) {
            self.cancelStackButton.isHidden = false
            self.doneButton.isHidden = false
        }
    }
    
    
    func saveWorkoutAndDismissController() {
        // Save the workout and set it's excercises to the tableview
        //1. Validate Textfield and current workout view
        if let workout = currentWorkout {
            workout.excercises = nil
            for (idx, excerciseString) in excercises.enumerated() {
                let excercise = ExcerciseTemplate(context: managedContext)
                excercise.name = excerciseString
                excercise.orderNumber = Int16(idx)
                workout.addToExcercises(excercise)
            }
            
            //2. Save the context to disc
            do {
                try managedContext.save()
                
                // send message to watch to update workouts
                PhoneConnectivityManager.newWorkoutCreatedMessage()
            } catch let error as NSError {
                print("Save error: \(error), description: \(error.userInfo)")
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Add Excercise Button Pressed
    @IBAction func addExcercisePressed(_ sender: Any) {
        animateToAddingExcerciseView()
        
        isAddingExcercise = true
        tableView.isEditing = false
        selectedRows = Array(repeating: false, count: existingExcercises.count)
        selectedExcercises = Array(repeating: "", count: existingExcercises.count)
        tableView.reloadData()
    }
    
    private func animateToAddingExcerciseView() {
        self.tableViewContainerView.alpha = 0
        self.addExcerciseButton.isHidden = true
        self.numberOfExcercisesLabel.isHidden = true
        self.findCreateStackView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.findButton.isHidden = false
        }, completion: { (isDone) in
            UIView.animate(withDuration: 0.1, animations: { 
                self.createNewExcerciseButton.isHidden = false
            })
        })
    }
    
    override func viewDidLayoutSubviews() {
        setupLineSeparator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLineSeparator()
    }
    
    func addExcerciseView(withText text: String?) {
        lineSeparator.alpha = 0
        addBlurEffect()
        
        excerciseView = AddExcerciseView(inView: view)
        excerciseView.textField.text = text ?? ""
        excerciseView.completionHandler = { (excerciseName) in
            // Add New Excercise ( Save was pressed.)
            if let excerciseName = excerciseName {
                self.excercises.append(excerciseName)
                self.tableView.reloadData()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffectView.alpha = 0
            }, completion: {_ in
                self.blurEffectView.removeFromSuperview()
                self.lineSeparator.alpha = 1.0
            })
            
        }
        
        view.addSubview(excerciseView)
        excerciseView.saveButton.addTarget(excerciseView, action: #selector(AddExcerciseView.savePressed), for: .touchUpInside)
        excerciseView.cancelButton.addTarget(excerciseView, action: #selector(AddExcerciseView.cancelPressed), for: .touchUpInside)
    }
    
    func reAdjustExcerciseViewOnOrienationChange() {
        let rect = AddExcerciseView.setupExcerciseViewFrame(inView: view)
        UIView.animate(withDuration: 0.5, animations: {
            self.excerciseView.frame.size.width = rect.width
            self.excerciseView.frame.size.height = rect.height
            self.excerciseView.saveButton.frame = self.excerciseView.saveButtonFrame()
            self.excerciseView.cancelButton.frame = self.excerciseView.cancelButtonFrame()
        })
    
    }
    
    func setupLineSeparator() {
        lineSeparator.translatesAutoresizingMaskIntoConstraints = false
        lineSeparator.backgroundColor = UIColor.white
        enterWorkoutNameContainerView.addSubview(lineSeparator)
        
        NSLayoutConstraint.activate([
            lineSeparator.topAnchor.constraint(equalTo: workoutNameTextfield.bottomAnchor, constant: 10),
            lineSeparator.centerXAnchor.constraint(equalTo: workoutNameTextfield.centerXAnchor),
            lineSeparator.widthAnchor.constraint(equalToConstant: 1),
            lineSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if excerciseView != nil {
            DispatchQueue.main.async {
                self.reAdjustExcerciseViewOnOrienationChange()
            }
        }
        
        DispatchQueue.main.async {
            self.animateLineSeparator()
        }
    }
    
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    
}

extension CreateWorkoutController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if workoutNameTextfield.isFirstResponder {
            workoutNameTextfield.resignFirstResponder()
            if isCheckedAndTrimmedWorkoutNamePassed() {
                removeWorkoutNameContainerView()
            }
        }
    }
    
    //MARK: - Create Workout Name Textfield or Start Editing Existing one
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
            
            if self.isCheckedAndTrimmedWorkoutNamePassed() {
                self.removeWorkoutNameContainerView()
            }
        
        }
        return true
    }
    
    func isCheckedAndTrimmedWorkoutNamePassed() -> Bool {
        if self.workoutNameTextfield.text != "" {
            let workoutName = self.workoutNameTextfield.text!.removeExtraWhiteSpace
            let workoutFetch: NSFetchRequest<WorkoutTemplate> = WorkoutTemplate.fetchRequest()
            workoutFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(WorkoutTemplate.name), workoutName)
            
            do {
                let results = try self.managedContext.fetch(workoutFetch)
                if results.count > 0 {
                    //Alert Notifying a workout is already named that.
                    present(AlertManager.alert(title: "Workout already exists.", message: "A workout is already named that. Please choose a different name.", style: .alert), animated: true)
                    return false
                } else {
                    // If editing an existing workout template don't create new one.
                    guard !self.isEditingExistingWorkout else {
                        self.updateWorkoutTemplate(workoutName: workoutName)
                        return true
                    }
                    // Brand New Workout Named -> Create a new workout with this name
                    self.navigationController?.title = workoutName
                    self.currentWorkout = WorkoutTemplate(context: self.managedContext)
                    self.currentWorkout?.name = workoutName
                    
                    return true
                }
            } catch let error as NSError {
                print("Fetch error: \(error), \(error.userInfo)")
            }
        } else {
            //Alert - Workout name has not been named
            present(AlertManager.alert(title: "A workout must have a name.", message: "Please name your workout.", style: .alert), animated: true)
            return false
        }
        
        present(AlertManager.alert(title: "Workout Name is Blank.", message: "Please name your workout.", style: .alert), animated: true)
        return false
    }

    
    func updateWorkoutTemplate(workoutName: String) {
        currentWorkout?.name = workoutName
    }
}

// MARK: - Animations
extension CreateWorkoutController {
    func animateLineSeparator() {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            let scaleX = CGFloat(self.view.bounds.size.width * 0.9)
            self.lineSeparator.transform = CGAffineTransform(scaleX: scaleX, y: 2)
        }, completion: nil)
    }
    
}



// MARK: - Table View Delegate / Datasource

extension CreateWorkoutController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isAddingExcercise {
            return excercises.count
        }
        
        if isAddingExcercise {
            return existingExcercises.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if !isAddingExcercise {
            let excercise = excercises[indexPath.row]
            
            cell.textLabel?.text = excercise
            cell.accessoryType = .none
            return cell
        } else {
            let existing = existingExcercises[indexPath.row]
            cell.textLabel?.text = existing
            cell.textLabel?.textColor = UIColor.white
            if selectedRows[indexPath.row] == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
}


extension CreateWorkoutController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isAddingExcercise {
            let excercise = excercises[indexPath.row]
            addExcerciseView(withText: excercise)
        }
        
        if isAddingExcercise {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                selectedRows[indexPath.row] = true
                selectedExcercises[indexPath.row] = existingExcercises[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isAddingExcercise {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
                selectedRows[indexPath.row] = false
                selectedExcercises[indexPath.row] = ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        excercises.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if !isAddingExcercise {
            let movedWorkout = excercises[sourceIndexPath.row]
            excercises.remove(at: sourceIndexPath.row)
            excercises.insert(movedWorkout, at: destinationIndexPath.row)
        }
    }
}

















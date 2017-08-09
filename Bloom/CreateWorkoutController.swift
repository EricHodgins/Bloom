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
    
    var excerciseView: AddExcerciseView!

    @IBOutlet weak var addExcerciseButton: UIButton!
    @IBOutlet weak var workoutNameTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let lineSeparator: UIView = UIView()
    var blurEffectView: UIVisualEffectView!
    
    var currentWorkout: WorkoutTemplate?
    
    var managedContext: NSManagedObjectContext!
    var workoutName: String? = nil
    var isEditingExistingWorkout: Bool = false
    var excercises: [String] = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = workoutName {
            workoutNameTextfield.text = name
            fetchWorkoutTemplate(name: name)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        workoutNameTextfield.delegate = self
    }
    
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


    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: Any) {
        
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
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addExcercisePressed(_ sender: Any) {
        addExcerciseView(withText: nil)
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
        view.addSubview(lineSeparator)
        
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
    
    //MARK: - Create Workout Name Textfield or Start Editing Existing one
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
            
            if self.workoutNameTextfield.text != "" {
                let workoutName = self.workoutNameTextfield.text!.removeExtraWhiteSpace
                let workoutFetch: NSFetchRequest<WorkoutTemplate> = WorkoutTemplate.fetchRequest()
                workoutFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(WorkoutTemplate.name), workoutName)
                
                do {
                    let results = try self.managedContext.fetch(workoutFetch)
                    if results.count > 0 {
                        //TODO: - Setup Alert Notifying a workout is already named that.
                    } else {
                        // If editing an existing workout template don't create new one.
                        guard !self.isEditingExistingWorkout else {
                            self.updateWorkoutTemplate(workoutName: workoutName)
                            return
                        }
                        // New Workout Named -> Create a new workout with this name
                        self.currentWorkout = WorkoutTemplate(context: self.managedContext)
                        self.currentWorkout?.name = workoutName
                    }
                } catch let error as NSError {
                    print("Fetch error: \(error), \(error.userInfo)")
                }
            }
        
        }
        return true
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
        return excercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let excercise = excercises[indexPath.row]
        
        cell.textLabel?.text = excercise
        
        return cell
    }
}


extension CreateWorkoutController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let excercise = excercises[indexPath.row] 
        addExcerciseView(withText: excercise)
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
}

















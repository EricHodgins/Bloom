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
    
    var currentWorkout: Workout?
    
    var managedContext: NSManagedObjectContext!
    var excercises: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        workoutNameTextfield.delegate = self
    }


    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: Any) {
        
        // Save the workout and set it's excercises to the tableview
        //1. Validate Textfield and current workout view
        if let workout = currentWorkout {
            for excerciseString in excercises {
                let excercise = Excercise(context: managedContext)
                excercise.name = excerciseString
                workout.addToExcercises(excercise)
            }
            
            //2. Save the context to disc
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Save error: \(error), description: \(error.userInfo)")
            }
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addExcercisePressed(_ sender: Any) {
        lineSeparator.alpha = 0
        addBlurEffect()
        addExcerciseView()
    }
    
    override func viewDidLayoutSubviews() {
        setupLineSeparator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateLineSeparator()
    }
    
    func addExcerciseView() {
        let rect = setupExcerciseViewFrame()
        excerciseView = AddExcerciseView(frame: rect)
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
        let rect = setupExcerciseViewFrame()
        UIView.animate(withDuration: 0.5, animations: {
            self.excerciseView.frame.size.width = rect.width
            self.excerciseView.frame.size.height = rect.height
            self.excerciseView.saveButton.frame = self.excerciseView.saveButtonFrame()
            self.excerciseView.cancelButton.frame = self.excerciseView.cancelButtonFrame()
        })
    
    }
    
    func setupExcerciseViewFrame() -> CGRect {
        let orientation = UIDevice.current.orientation
        let rect: CGRect
        
        if orientation == .portrait {
           rect = CGRect(x: 25, y: 50, width: view.frame.size.width - 50, height: view.frame.size.height * 0.5)
        } else {
           rect = CGRect(x: 25, y: 25, width: view.frame.size.width - 50, height: view.frame.size.height * 0.8)
        }
        
        return rect
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
    
    //MARK: - Create Workout Name Textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        
        if workoutNameTextfield.text != "" {
            let workoutFetch: NSFetchRequest<Workout> = Workout.fetchRequest()
            workoutFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Workout.name), workoutNameTextfield.text!)
            
            do {
                let results = try managedContext.fetch(workoutFetch)
                if results.count > 0 {
                    // Already have a workout called that
                    //TODO: - Setup Alert Notifying a workout is already named that.
                } else {
                    // New Workout Named -> Create a new workout with this name
                    currentWorkout = Workout(context: managedContext)
                    currentWorkout?.name = workoutNameTextfield.text!
                    try managedContext.save()
                }
            } catch let error as NSError {
                print("Fetch error: \(error), \(error.userInfo)")
            }
        }
        
        return true
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




















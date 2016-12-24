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
    
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        workoutNameTextfield.delegate = self
    }


    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: Any) {
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
        view.addSubview(excerciseView)
        
        excerciseView.saveButton.addTarget(self, action: #selector(CreateWorkoutController.addedNewExcercise), for: .touchUpInside)
        excerciseView.cancelButton.addTarget(self, action: #selector(CreateWorkoutController.cancelledAddingExcercise), for: .touchUpInside)
        
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
    
    func animateAddExceciseViewOffFromSuperView() {
        addExcerciseButton.isEnabled = true
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.excerciseView.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1.0, animations: {
                self.excerciseView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            
            
        }, completion: {_ in
            self.excerciseView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffectView.alpha = 0
            }, completion: {_ in
                self.blurEffectView.removeFromSuperview()
                self.lineSeparator.alpha = 1.0
            })
            
        })
        
    }
    
    func addedNewExcercise() {
        animateAddExceciseViewOffFromSuperView()
    }
    
    func cancelledAddingExcercise() {
        animateAddExceciseViewOffFromSuperView()
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
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
























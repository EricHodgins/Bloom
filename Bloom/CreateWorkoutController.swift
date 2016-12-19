//
//  CreateWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-17.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

class CreateWorkoutController: UIViewController {

    @IBOutlet weak var workoutNameTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let lineSeparator: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        workoutNameTextfield.delegate = self
    }


    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: Any) {
        
    }
    
    @IBAction func addExcercisePressed(_ sender: Any) {
        
    }
    
    override func viewDidLayoutSubviews() {
        setupLineSeparator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateLineSeparator()
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
























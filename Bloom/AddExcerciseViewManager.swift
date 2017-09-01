//
//  AddExcerciseViewManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-31.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

protocol AddExcerciseProtocol: class {
    func addPressedFromAddExcerciseView()
}

class AddExcerciseViewManager {
    var numberLabel: UILabel!
    var addExcercisesButton: GenericBloomButton!
    var tableView: UITableView!
    
    let controller: CreateController
    let view: UIView
    
    weak var delegate: AddExcerciseProtocol?
    
    init(controller: CreateController) {
        self.view = controller.view
        self.controller = controller
        setupNumberOfExcercisesLabel()
        setupAddExcerciseButton()
        setupTableView()
    }
    
    private func setupNumberOfExcercisesLabel() {
        numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.text = "Number of Excercises: 0"
        numberLabel.textColor = UIColor.white
        numberLabel.font = .systemFont(ofSize: 21)
        
        view.addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: controller.topLayoutGuide.bottomAnchor, constant: 0),
            numberLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            numberLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            numberLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.backgroundColor = UIColor.clear
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: numberLabel.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: addExcercisesButton.topAnchor)
        ])
    }
    
    private func setupAddExcerciseButton() {
        addExcercisesButton = GenericBloomButton()
        addExcercisesButton.translatesAutoresizingMaskIntoConstraints = false
        addExcercisesButton.startColor = UIColor.blue
        addExcercisesButton.endColor = UIColor.white
        addExcercisesButton.setTitle("Add Excercise", for: .normal)
        addExcercisesButton.setTitleColor(UIColor.white, for: .normal)
        addExcercisesButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        addExcercisesButton.addTarget(self, action: #selector(AddExcerciseViewManager.addPushed), for: .touchUpInside)
        
        view.addSubview(addExcercisesButton)
        addExcercisesButton.setup() // This Draws the button to screen.
        
        NSLayoutConstraint.activate([
            addExcercisesButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            addExcercisesButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            addExcercisesButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            addExcercisesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addPushed() {

        animate() {
            self.tableView.removeFromSuperview()
            self.numberLabel.removeFromSuperview()
            self.addExcercisesButton.removeFromSuperview()
            self.delegate?.addPressedFromAddExcerciseView()
        }
    }
    
    private func animate(completion: (() -> Void)?) {
        
        UIView.animate(withDuration: 0.1) { 
            self.tableView.alpha = 0
            self.numberLabel.alpha = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.addExcercisesButton.center = self.view.center
        })
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.addExcercisesButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1.0, animations: {
                self.addExcercisesButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            
        }, completion: {_ in
            completion?()
        })
    }
}
































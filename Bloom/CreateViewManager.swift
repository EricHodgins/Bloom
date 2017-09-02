//
//  CreateViewManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-31.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

protocol CreateViewManagerDelegate: class {
    func cancelPressedFromCreateView()
    func donePressedFromCreateView()
}

class CreateViewManager {
    
    var textField: UITextField!
    var setsLabel: UILabel!
    var setsSwitch: UISwitch!
    var repsLabel: UILabel!
    var repsSwitch: UISwitch!
    var weightLabel: UILabel!
    var weightSwitch: UISwitch!
    var distanceLabel: UILabel!
    var distanceSwitch: UISwitch!
    
    var cancelButton: GenericBloomButton!
    var doneButton: GenericBloomButton!
    
    weak var delegate: CreateViewManagerDelegate?
    
    let view: UIView
    
    init(view: UIView) {
        self.view = view
        setupCancelButton()
        setupDoneButton()
        animateButtonsOnScreen()
    }
    
    //MARK: - Textfield Setup
    private func setupTextfield() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 21)
        textField.textColor = UIColor.white
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        textField.attributedPlaceholder = NSAttributedString(string: "Name Your Excercise",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height*0.3),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8)
        ])
    }
    
    //MARK: - Sets Setup
    private func setupSetsLabel() {
        setsLabel = UILabel()
        setsLabel.translatesAutoresizingMaskIntoConstraints = false
        setsLabel.text = "Sets"
        setsLabel.textColor = UIColor.white
        setsLabel.font = .systemFont(ofSize: 21)
        
        view.addSubview(setsLabel)
        
        NSLayoutConstraint.activate([
            setsLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            setsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            setsLabel.heightAnchor.constraint(equalToConstant: 40),
            setsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 0)
        ])
    }
    
    private func setupSetsSwitch() {
        setsSwitch = UISwitch()
        setsSwitch.translatesAutoresizingMaskIntoConstraints = false
        setsSwitch.setOn(false, animated: false)
        
        view.addSubview(setsSwitch)
        
        NSLayoutConstraint.activate([
            setsSwitch.centerYAnchor.constraint(equalTo: setsLabel.centerYAnchor),
            setsSwitch.leftAnchor.constraint(equalTo: setsLabel.rightAnchor),
            setsSwitch.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    //MARK: - Reps Setup
    private func setupRepsLabel() {
        repsLabel = UILabel()
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        repsLabel.text = "Reps"
        repsLabel.textColor = UIColor.white
        repsLabel.font = .systemFont(ofSize: 21)
        
        view.addSubview(repsLabel)
        
        NSLayoutConstraint.activate([
            repsLabel.topAnchor.constraint(equalTo: setsLabel.bottomAnchor, constant: 16),
            repsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            repsLabel.heightAnchor.constraint(equalToConstant: 40),
            repsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 0)
        ])
    }
    
    private func setupRepsSwitch() {
        repsSwitch = UISwitch()
        repsSwitch.translatesAutoresizingMaskIntoConstraints = false
        repsSwitch.setOn(false, animated: false)
        
        view.addSubview(repsSwitch)
        
        NSLayoutConstraint.activate([
            repsSwitch.centerYAnchor.constraint(equalTo: repsLabel.centerYAnchor),
            repsSwitch.leftAnchor.constraint(equalTo: repsLabel.rightAnchor),
            repsSwitch.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    //MARK: - Weights Setup
    private func setupWeightLabel() {
        weightLabel = UILabel()
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.text = "Weight"
        weightLabel.textColor = UIColor.white
        weightLabel.font = .systemFont(ofSize: 21)
        
        view.addSubview(weightLabel)
        
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: repsLabel.bottomAnchor, constant: 16),
            weightLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            weightLabel.heightAnchor.constraint(equalToConstant: 40),
            weightLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 0)
        ])
    }
    
    private func setupWeightSwitch() {
        weightSwitch = UISwitch()
        weightSwitch.translatesAutoresizingMaskIntoConstraints = false
        weightSwitch.setOn(false, animated: false)
        
        view.addSubview(weightSwitch)
        
        NSLayoutConstraint.activate([
            weightSwitch.centerYAnchor.constraint(equalTo: weightLabel.centerYAnchor),
            weightSwitch.leftAnchor.constraint(equalTo: repsLabel.rightAnchor),
            weightSwitch.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    //MARK: - Distance Setup
    private func setupDistanceLabel() {
        distanceLabel = UILabel()
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.text = "Distance"
        distanceLabel.textColor = UIColor.white
        distanceLabel.font = .systemFont(ofSize: 21)
        
        view.addSubview(distanceLabel)
        
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 16),
            distanceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            distanceLabel.heightAnchor.constraint(equalToConstant: 40),
            distanceLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 0)
        ])
    }
    
    private func setupDistanceSwitch() {
        distanceSwitch = UISwitch()
        distanceSwitch.translatesAutoresizingMaskIntoConstraints = false
        distanceSwitch.setOn(false, animated: false)
        
        view.addSubview(distanceSwitch)
        
        NSLayoutConstraint.activate([
            distanceSwitch.centerYAnchor.constraint(equalTo: distanceLabel.centerYAnchor),
            distanceSwitch.leftAnchor.constraint(equalTo: repsLabel.rightAnchor),
            distanceSwitch.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    //MARK: - Setup Buttons
    private func setupCancelButton() {
        cancelButton = GenericBloomButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.startColor = UIColor.cancelStart
        cancelButton.endColor = UIColor.cancelEnd
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        cancelButton.addTarget(self, action: #selector(CreateViewManager.cancelPressed), for: .touchUpInside)
        
        view.addSubview(cancelButton)
        cancelButton.setup() // This Draws the button to screen.
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -4)
            ])
        
        cancelButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    private func setupDoneButton() {
        doneButton = GenericBloomButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.startColor = UIColor.doneStart
        doneButton.endColor = UIColor.doneEnd
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        doneButton.addTarget(self, action: #selector(CreateViewManager.donePressed), for: .touchUpInside)
        
        view.addSubview(doneButton)
        doneButton.setup() // This Draws the button to screen.
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            doneButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -4)
            ])
        
        doneButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

    }
    
    @objc func cancelPressed() {
        animateButtonsOffScreen() {
            self.delegate?.cancelPressedFromCreateView()
        }
    }
    
    @objc func donePressed() {
        animateButtonsOffScreen { 
            self.delegate?.donePressedFromCreateView()
        }
    }
    
    //MARK: - Animations
    private func animateButtonsOnScreen() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.cancelButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
                self.doneButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1.0, animations: {
                self.cancelButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.doneButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            
        }, completion: {_ in
            self.setupTextfield()
            self.setupSetsLabel()
            self.setupSetsSwitch()
            self.setupRepsLabel()
            self.setupRepsSwitch()
            self.setupWeightLabel()
            self.setupWeightSwitch()
            self.setupDistanceLabel()
            self.setupDistanceSwitch()
        })
    }
    
    private func animateButtonsOffScreen(completion: (() -> Void)?) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.cancelButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
                self.doneButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1.0, animations: {
                self.cancelButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.doneButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            
        }, completion: {_ in
            self.cancelButton.removeFromSuperview()
            self.doneButton.removeFromSuperview()
            self.textField.removeFromSuperview()
            self.setsLabel.removeFromSuperview()
            self.setsSwitch.removeFromSuperview()
            self.repsLabel.removeFromSuperview()
            self.weightLabel.removeFromSuperview()
            self.weightSwitch.removeFromSuperview()
            self.distanceLabel.removeFromSuperview()
            self.distanceSwitch.removeFromSuperview()
            completion?()
        })
    }
    
}





































//
//  NameWorkoutViewManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-31.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class NameWorkoutViewManager {
    
    let view: UIView
    var textField: UITextField!
    var lineSeparator: UIView!
    var cancelButton: GenericBloomButton!
    var nextButton: GenericBloomButton!
    
    init(view: UIView) {
        self.view = view
        setupTextField()
        setupLineSeparator()
        setupCancelButton()
        setupNextButton()
    }
    
    fileprivate func setupTextField() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 21)
        textField.textColor = UIColor.white
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        textField.attributedPlaceholder = NSAttributedString(string: "Name Your Workout",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height*0.2),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8)
        ])
    }
    
    fileprivate func setupLineSeparator() {
        lineSeparator = UIView()
        lineSeparator.translatesAutoresizingMaskIntoConstraints = false
        lineSeparator.backgroundColor = UIColor.white
        
        view.addSubview(lineSeparator)
        
        NSLayoutConstraint.activate([
            lineSeparator.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 0),
            lineSeparator.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            lineSeparator.widthAnchor.constraint(equalToConstant: 1),
            lineSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    fileprivate func setupCancelButton() {
        cancelButton = GenericBloomButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.startColor = UIColor.red
        cancelButton.endColor = UIColor.orange
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        view.addSubview(cancelButton)
        cancelButton.setup() // This Draws the button to screen.
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: lineSeparator.bottomAnchor, constant: 8),
            cancelButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -16)
        ])
    }
    
    fileprivate func setupNextButton() {
        nextButton = GenericBloomButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.startColor = UIColor.blue
        nextButton.endColor = UIColor.white
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        view.addSubview(nextButton)
        nextButton.setup() // This Draws the button to screen.
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: lineSeparator.bottomAnchor, constant: 8),
            nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -16)
        ])
    }
    
    public func animateLineSeparator() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            let scaleX = CGFloat(self.view.bounds.size.width * 0.9)
            self.lineSeparator.transform = CGAffineTransform(scaleX: scaleX, y: 2)
        }, completion: nil)
    }
}






































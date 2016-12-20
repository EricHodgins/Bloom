//
//  AddExcerciseView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-19.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit


class AddExcerciseView: UIView {
    
    let textField: UITextField =  UITextField()
    let lineSeparator: UIView = UIView()
    
    var saveButton: UIButton!
    var cancelButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        lineSeparator.backgroundColor = UIColor.red
        self.alpha = 0.75
        
        textField.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        textField.delegate = self
        
        saveButton = UIButton(frame: saveButtonFrame())
        saveButton.backgroundColor = UIColor(red: 1/255, green: 73/255, blue: 188/255, alpha: 1.0)
        saveButton.setTitle("Save", for: .normal)
        saveButton.alpha = 0
        addSubview(saveButton)
        
        cancelButton = UIButton(frame: cancelButtonFrame())
        cancelButton.backgroundColor = UIColor(red: 232/255, green: 39/255, blue: 39/255, alpha: 1.0)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.alpha = 0
        addSubview(cancelButton)
        
        setupTextField()
        setupLineSeparator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animateLineSeparator()
    }
    
    func saveButtonFrame() -> CGRect {
        return CGRect(x: 0, y: bounds.size.height - 60, width: bounds.size.width/2, height: 60)
    }
    
    func cancelButtonFrame() -> CGRect {
        return CGRect(x: bounds.size.width/2, y: bounds.size.height - 60, width: bounds.size.width/2, height: 60)
    }
    
    func setupLineSeparator() {
        
        lineSeparator.translatesAutoresizingMaskIntoConstraints = false
        lineSeparator.backgroundColor = UIColor.red
        addSubview(lineSeparator)
        
        NSLayoutConstraint.activate([
            lineSeparator.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 3),
            lineSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),
            lineSeparator.widthAnchor.constraint(equalToConstant: 1),
            lineSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupTextField() {
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Excercise Name"
        textField.textAlignment = .center
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            textField.widthAnchor.constraint(equalToConstant: bounds.size.width - 20),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func didMoveToSuperview() {
        animateUIElements()
    }
    
    func animateUIElements() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            let scaleX = CGFloat(self.bounds.size.width * 0.9)
            self.lineSeparator.transform = CGAffineTransform(scaleX: scaleX, y: 2)
        }, completion: {_ in
            
            let fade = CABasicAnimation(keyPath: "opacity")
            fade.fromValue = 0
            fade.toValue = 1.0
            fade.duration = 0.3
            self.saveButton.layer.add(fade, forKey: nil)
            self.cancelButton.layer.add(fade, forKey: nil)
            self.saveButton.layer.opacity = 1.0
            self.cancelButton.layer.opacity = 1.0
        })
    }
    
    func animateLineSeparator() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            let scaleX = CGFloat(self.bounds.size.width * 0.9)
            self.lineSeparator.transform = CGAffineTransform(scaleX: scaleX, y: 2)
        }, completion: nil)
    }
    
}


extension AddExcerciseView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


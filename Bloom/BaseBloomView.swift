//
//  BaseBloomView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class BaseBloomView: UIView {
    
    let textField: UITextField =  UITextField()
    let lineSeparator: UIView = UIView()
    
    var saveButton: UIButton!
    var cancelButton: UIButton!
    
    var completionHandler: ((_ name: String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        lineSeparator.backgroundColor = UIColor.red
        self.alpha = 1.0
        
        textField.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        
        saveButton = UIButton(frame: saveButtonFrame())
        saveButton.backgroundColor = UIColor(red: 1/255, green: 73/255, blue: 188/255, alpha: 1.0)
        saveButton.setTitle("Save", for: .normal)
        addSubview(saveButton)
        
        cancelButton = UIButton(frame: cancelButtonFrame())
        cancelButton.backgroundColor = UIColor(red: 232/255, green: 39/255, blue: 39/255, alpha: 1.0)
        cancelButton.setTitle("Cancel", for: .normal)
        addSubview(cancelButton)
        
        setupTextField()
        setupLineSeparator()
    }
    
    convenience init(inView view: UIView) {
        let rect = BaseBloomView.setupExcerciseViewFrame(inView: view)
        self.init(frame: rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented.")
    }

    override func draw(_ rect: CGRect) {
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
    
    func saveButtonFrame() -> CGRect {
        return CGRect(x: bounds.size.width/2, y: bounds.size.height - 60, width: bounds.size.width/2, height: 60)
    }
    
    func cancelButtonFrame() -> CGRect {
        return CGRect(x: 0, y: bounds.size.height - 60, width: bounds.size.width/2, height: 60)
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
            textField.topAnchor.constraint(equalTo: topAnchor, constant: bounds.size.height/3 - 20),
            textField.widthAnchor.constraint(equalToConstant: bounds.size.width - 20),
            textField.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    override func didMoveToSuperview() {
        animateUIElements()
        
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.fromValue = 0.01
        anim.toValue = 1
        anim.duration = 0.25
        layer.add(anim, forKey: nil)
    }
    
    func animateUIElements() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            let scaleX = CGFloat(self.bounds.size.width * 0.9)
            self.lineSeparator.transform = CGAffineTransform(scaleX: scaleX, y: 2)
        }, completion: {_ in
            
        })
    }
    
    func animateLineSeparator() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            let scaleX = CGFloat(self.bounds.size.width * 0.9)
            self.lineSeparator.transform = CGAffineTransform(scaleX: scaleX, y: 2)
        }, completion: nil)
    }
    
    class func setupExcerciseViewFrame(inView view: UIView) -> CGRect {
        let rect: CGRect
        
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        
        if viewWidth < viewHeight {
            rect = CGRect(x: 25, y: 50, width: view.frame.size.width - 50, height: view.frame.size.height * 0.5)
        } else {
            rect = CGRect(x: 25, y: 25, width: view.frame.size.width - 50, height: view.frame.size.height * 0.8)
        }
        
        return rect
    }
}


extension BaseBloomView {
    @objc func savePressed() {
        if textField.text != "" {
            let text = self.textField.text!.removeExtraWhiteSpace
            completionHandler!(text)
            removeViewFromSuperViewAnimation()
        }
    }
    
    @objc func cancelPressed() {
        completionHandler!(nil)
        removeViewFromSuperViewAnimation()
    }
    
    func removeViewFromSuperViewAnimation() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1.0, animations: {
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            
        }, completion: {_ in
            self.removeFromSuperview()
        })
    }
}

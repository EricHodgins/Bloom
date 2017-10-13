//
//  FindAndCreateViewManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-09-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

protocol FindAndCreateViewProtocol: class {
    func findButtonPressed()
    func createButtonPressed()
}

class FindAndCreateViewManager {
    var findButton: GenericBloomButton!
    var createButton: GenericBloomButton!
    let view: UIView
    
    weak var delegate: FindAndCreateViewProtocol?
    
    init(view: UIView) {
        self.view = view
        setupFindButton()
        setupCreateButton()
        animateButtonsOnScreen()
    }
    
    private func setupFindButton() {
        findButton = GenericBloomButton()
        findButton.translatesAutoresizingMaskIntoConstraints = false
        findButton.startColor = UIColor.findStart
        findButton.endColor = UIColor.findEnd
        findButton.setTitle("Find", for: .normal)
        findButton.setTitleColor(UIColor.white, for: .normal)
        findButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        findButton.addTarget(self, action: #selector(FindAndCreateViewManager.findPushed), for: .touchUpInside)
        
        view.addSubview(findButton)
        findButton.setup() // This Draws the button to screen.
        
        NSLayoutConstraint.activate([
            findButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            findButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            findButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            findButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -16)
        ])
        
        findButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    private func setupCreateButton() {
        createButton = GenericBloomButton()
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.startColor = UIColor.createStart
        createButton.endColor = UIColor.createEnd
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        createButton.addTarget(self, action: #selector(FindAndCreateViewManager.createPushed), for: .touchUpInside)
        
        view.addSubview(createButton)
        createButton.setup() // This Draws the button to screen.
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            createButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            createButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            createButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -16)
        ])
        
        createButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    @objc private func findPushed() {
        animateButtonsOffScreen() {
            self.delegate?.findButtonPressed()
        }
    }

   @objc private func createPushed() {
        animateButtonsOffScreen() {
            self.delegate?.createButtonPressed()
        }
    }
    
    //MARK: - Animations
    private func animateButtonsOnScreen() {
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.findButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
                self.createButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.12, relativeDuration: 1.0, animations: {
                self.findButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.createButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            
        }, completion: {_ in
            
        })
    }
    
    private func animateButtonsOffScreen(completion: (() -> Void)?) {
        
        UIView.animate(withDuration: 0.25) {
            let yCoord: CGFloat = self.view.frame.height - (self.findButton.frame.height / 2)
            self.findButton.center = CGPoint(x: self.findButton.center.x, y: yCoord)
            self.createButton.center = CGPoint(x: self.createButton.center.x, y: yCoord)
        }
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                self.findButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
                self.createButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.12, relativeDuration: 1.0, animations: {
                self.findButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.createButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            
        }, completion: {_ in
            self.findButton.removeFromSuperview()
            self.createButton.removeFromSuperview()
            completion?()
        })
    }
    
}

































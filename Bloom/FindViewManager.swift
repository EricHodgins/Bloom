//
//  FindViewManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-31.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

protocol FindViewManagerProtocol: class {
    func cancelPressedFromFindViewManager()
    func donePressedFromFindViewManager()
}


class FindViewManager {
    var cancelButton: GenericBloomButton!
    var doneButton: GenericBloomButton!
    var tableView: UITableView!
    let view: UIView
    let controller: CreateController
    
    weak var delegate: FindViewManagerProtocol?
    
    init(controller: CreateController) {
        self.view = controller.view
        self.controller = controller
        self.delegate = controller
        setupCancelButton()
        setupDoneButton()
        animateButtonsOnScreen()
    }
    
    func setupCancelButton() {
        cancelButton = GenericBloomButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.startColor = UIColor.red
        cancelButton.endColor = UIColor.orange
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        cancelButton.addTarget(self, action: #selector(FindViewManager.cancelPressed), for: .touchUpInside)
        
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
    
    func setupDoneButton() {
        doneButton = GenericBloomButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.startColor = UIColor.blue
        doneButton.endColor = UIColor.white
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        doneButton.addTarget(self, action: #selector(FindViewManager.donePressed), for: .touchUpInside)
        
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
    
    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.backgroundColor = UIColor.clear
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: controller.topLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor)
        ])
    }
    
    @objc func cancelPressed() {
        animateButtonsOffScreen { 
            self.delegate?.cancelPressedFromFindViewManager()
        }
    }
    
    @objc func donePressed() {
        animateButtonsOffScreen { 
            self.delegate?.donePressedFromFindViewManager()
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
            self.setupTableView()
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
            self.tableView.removeFromSuperview()
            completion?()
        })
    }
}


























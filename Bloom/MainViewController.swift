//
//  ViewController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-12.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var createWorkoutButton: CreateWorkoutButton = {
        let button = CreateWorkoutButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setupButtonLayout() {
        view.addSubview(createWorkoutButton)
    }
}


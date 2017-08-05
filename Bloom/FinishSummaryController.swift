//
//  FinishSummaryController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-04.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import SpriteKit

class FinishSummaryController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = FinishScene(size: self.view.frame.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.backgroundColor = UIColor.clear
        skView.presentScene(scene)
    }
}

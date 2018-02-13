//
//  DustParticleScene.swift
//  Bloom
//
//  Created by Eric Hodgins on 2018-02-13.
//  Copyright © 2018 Eric Hodgins. All rights reserved.
//

import UIKit
import SpriteKit

class DustParticleScene: SKScene {
    
    var sceneView: SKView?
    var particles: SKEmitterNode?
    
    override func didMove(to view: SKView) {
        sceneView = view
        sceneView?.backgroundColor = UIColor.clear
        addParticles()
    }
    
    func addParticles() {
        if let particlesSKS = SKEmitterNode(fileNamed: "DustParticles.sks") {
            particles = particlesSKS
            particles!.position = CGPoint(x: (self.sceneView?.frame.width)!/2, y: (self.sceneView?.frame.height)! / 2)
            self.addChild(particles!)
        }
    }
}

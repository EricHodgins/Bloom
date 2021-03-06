//
//  FinishScene.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-04.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import SpriteKit
import CoreImage

class FinishScene: SKScene {
    
    var inputOrigin = CIVector(x: 100, y: 100)
    var inputColor = CIVector(x: 0/255, y: 45/255, z: 135/255)
    
    var goRight: Bool = true
    var goUp: Bool = true
    var redColor: CGFloat = 0
    var redShiftDown: Bool = false
    var widthDistance: CGFloat = 0
    var heightDistance: CGFloat = 0
    
    var effectNode: SKEffectNode!
    var sceneView: SKView!
    
    lazy var sunFlare: LensFlare = {
        return LensFlare()
    }()
    
    var particles: SKEmitterNode?
    
    override func didMove(to view: SKView) {
        self.sceneView = view
        heightDistance = sceneView.frame.height //* 0.75
        backgroundColor = SKColor.black
        
        let scalex:CGFloat = 1
        let scaley:CGFloat = 1
        let shapeRect = CGRect(x: 0, y: 0, width: sceneView.frame.width*scalex, height: sceneView.frame.height*scaley)
        let shape = SKShapeNode(rect: shapeRect)
        shape.position = CGPoint.zero
        
        sunFlare.inputSize = CIVector(x: sceneView.frame.width, y: sceneView.frame.height)
        
        effectNode = SKEffectNode()
        effectNode.setScale(2.0) // Not sure why this needs to be scaled to fit the screen yet.
        effectNode.filter = sunFlare
        effectNode.shouldEnableEffects = true
        effectNode.shouldCenterFilter = true
        effectNode.addChild(shape)
        
        addChild(effectNode)
    }
    
    func removeFlareAction() {
        effectNode.removeAllActions()
        particles?.removeFromParent()
    }
    
    func addParticles() {
        if let particlesSKS = SKEmitterNode(fileNamed: "DustParticles.sks") {
            particles = particlesSKS
            particles!.position = CGPoint(x: self.sceneView.frame.width/2, y: self.sceneView.frame.height / 2)
            self.addChild(particles!)
        }
    }
    
    func startSunFlareAction() {
        addParticles()
        
        let speed: CGFloat = 2.5
        var dt: CGFloat = 0
        var lastUpdateTime: CGFloat = 0
        let flareAction = SKAction.customAction(withDuration: 300) { (node, elapsed) in
            if lastUpdateTime == 0 {
                dt = elapsed
            } else {
                dt = elapsed - lastUpdateTime
            }
            lastUpdateTime = elapsed
            
            self.sunFlare.sunbeamsFilter?.setValue(elapsed*0.01, forKey: kCIInputTimeKey)
            
            
            if self.widthDistance >= self.sceneView.frame.width {
                self.goRight = false
            } else if self.widthDistance <= 0 {
                self.goRight = true
            }
            
            if self.goRight {
                self.widthDistance += speed * dt
            } else {
                self.widthDistance -= speed * dt
            }
            
            if self.heightDistance >= self.sceneView.frame.height {
                self.goUp = false
            } else if self.heightDistance <= 0 {
                self.goUp = true
            }
            
            if self.goUp {
                //self.heightDistance += speed * dt
            } else {
                //self.heightDistance -= speed * dt
            }
            
            self.sunFlare.inputOrigin = CIVector(x: self.widthDistance, y: self.heightDistance)
            
            if self.redColor > 0.78 {
                self.redShiftDown = true
            } else if self.redColor <= 0 {
                self.redShiftDown = false
            }
            
            if self.redShiftDown {
                self.redColor -= 0.0001
            } else {
                self.redColor += 0.0001
            }
            self.sunFlare.inputColor = CIVector(x: self.redColor, y: 45/255, z: 135/255)
            
            self.effectNode.shouldEnableEffects = true
        }
        
        effectNode.run(flareAction)
    }
    
}



























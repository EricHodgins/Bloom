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
    
    var effectNode: SKEffectNode!
    var sceneView: SKView!
    
    lazy var sunFlare: LensFlare = {
        return LensFlare()
    }()
    
    override func didMove(to view: SKView) {
        self.sceneView = view
        backgroundColor = SKColor.black
        
        let scalex:CGFloat = 1
        let scaley:CGFloat = 1
        let shapeRect = CGRect(x: 0, y: 0, width: sceneView.frame.width*scalex, height: sceneView.frame.height*scaley)
        let shape = SKShapeNode(rect: shapeRect)
        shape.position = CGPoint.zero
        
        //let sunFlare = LensFlare()
        sunFlare.inputSize = CIVector(x: sceneView.frame.width, y: sceneView.frame.height)
        
        effectNode = SKEffectNode()
        effectNode.setScale(2.0) // Not sure why this needs to be scaled to fit the screen yet.
        effectNode.filter = sunFlare
        effectNode.shouldEnableEffects = true
        effectNode.shouldCenterFilter = true
        effectNode.addChild(shape)
        
        addChild(effectNode)
        
        startSunFlareAction()
    }
    
    func removeFlareAction() {
        effectNode.removeAllActions()
    }
    
    func startSunFlareAction() {

        
        let speed: CGFloat = 20
        var widthDistance: CGFloat = 0
        var heightDistance: CGFloat = 0
        var dt: CGFloat = 0
        var lastUpdateTime: CGFloat = 0
        var goRight: Bool = true
        var goUp: Bool = true
        let flareAction = SKAction.customAction(withDuration: 300) { (node, elapsed) in
            if lastUpdateTime == 0 {
                dt = elapsed
            } else {
                dt = elapsed - lastUpdateTime
            }
            lastUpdateTime = elapsed
            
            self.sunFlare.sunbeamsFilter?.setValue(elapsed*0.009, forKey: kCIInputTimeKey)
            
            
            if widthDistance >= self.sceneView.frame.width {
                goRight = false
            } else if widthDistance <= 0 {
                goRight = true
            }
            
            if goRight {
                widthDistance += speed * dt
            } else {
                widthDistance -= speed * dt
            }
            
            if heightDistance >= self.sceneView.frame.height {
                goUp = false
            } else if heightDistance <= 0 {
                goUp = true
            }
            
            if goUp {
                heightDistance += speed * dt
            } else {
                heightDistance -= speed * dt
            }
            
            self.sunFlare.inputOrigin = CIVector(x: widthDistance, y: heightDistance)
            self.sunFlare.inputColor = CIVector(x: (elapsed * 5)/255, y: 45/255, z: 135/255)
            
            
            self.effectNode.shouldEnableEffects = true
        }
        
        effectNode.run(flareAction)
    }
    
}



























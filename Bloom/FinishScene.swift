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
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let scalex:CGFloat = 1
        let scaley:CGFloat = 1
        let shapeRect = CGRect(x: 0, y: 0, width: view.frame.width*scalex, height: view.frame.height*scaley)
        let shape = SKShapeNode(rect: shapeRect)
        shape.position = CGPoint.zero

        let sunFlare = LensFlare()
        sunFlare.inputSize = CIVector(x: view.frame.width, y: view.frame.height)
        
        let effectNode = SKEffectNode()
        effectNode.setScale(2.0) // Not sure why this needs to be scaled to fit the screen yet.
        effectNode.filter = sunFlare
        effectNode.shouldEnableEffects = true
        effectNode.shouldCenterFilter = true
        effectNode.addChild(shape)
        
        addChild(effectNode)
        
        let topLeft = CGPoint(x: 0, y: view.frame.height)
        
        let flareAction = SKAction.customAction(withDuration: 300) { (node, elapsed) in
            sunFlare.sunbeamsFilter?.setValue(elapsed*0.009, forKey: kCIInputTimeKey)
            sunFlare.inputOrigin = CIVector(x: 0 + (elapsed*3), y: (view.frame.height - 100) + elapsed)//CIVector(x: 50 + (elapsed * 10), y: 75 + (elapsed * 60))
            sunFlare.inputColor = CIVector(x: (elapsed * 2)/255, y: 45/255, z: 135/255)
            effectNode.shouldEnableEffects = true
        }
        
        effectNode.run(flareAction)
        
    }
    
}



























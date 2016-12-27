//
//  CreateWorkoutButton.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-16.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

@IBDesignable
class CreateWorkoutButton: GenericBloomButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Draw the plus sign
        let plusPath = UIBezierPath()
        //plusPath.lineWidth = 4.0
        
        // Vertical line
        plusPath.move(to: CGPoint(x: 25, y: 10))
        plusPath.addLine(to: CGPoint(x: 24, y: 40))
        
        // horizontal
        plusPath.move(to: CGPoint(x: 10, y: 25))
        plusPath.addLine(to: CGPoint(x: 40, y: 25))

        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = plusPath.cgPath
        shapeLayer.lineWidth = 4.0
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeColor = fillColor.cgColor
        layer.addSublayer(shapeLayer)
        
    }

}

//
//  BeginWorkoutButton.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-17.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit


@IBDesignable
class BeginWorkoutButton: GenericBloomButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Head
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: CGPoint(x: 33, y: 20), radius: 5, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        // Body
        let bodyPath = UIBezierPath()
        bodyPath.lineWidth = 3.0
        bodyPath.move(to: CGPoint(x: 31, y: 26))
        bodyPath.addLine(to: CGPoint(x: 23, y: 45))
        
        // Right arm
        let rightArmPath = UIBezierPath()
        rightArmPath.lineWidth = 3.0
        rightArmPath.move(to: CGPoint(x: 31, y: 34))
        rightArmPath.addLine(to: CGPoint(x: 44, y: 40))
        
        // Left arm
        let leftArmPath = UIBezierPath()
        leftArmPath.lineWidth = 3.0
        leftArmPath.move(to: CGPoint(x: 25, y: 32))
        leftArmPath.addLine(to: CGPoint(x: 16, y: 39))
        
        // Right leg
        let rightLegPath = UIBezierPath()
        rightLegPath.lineWidth = 3.0
        rightLegPath.move(to: CGPoint(x: 24, y: 46))
        rightLegPath.addLine(to: CGPoint(x: 30, y: 55))
        rightLegPath.move(to: CGPoint(x: 30, y: 55))
        rightLegPath.addLine(to: CGPoint(x: 20, y: 65))
        
        // Left Leg
        let leftLegPath = UIBezierPath()
        leftLegPath.lineWidth = 3.0
        leftLegPath.move(to: CGPoint(x: 22, y: 45))
        leftLegPath.addLine(to: CGPoint(x: 12, y: 66))
        
        let workoutManPath = UIBezierPath()
        workoutManPath.append(circlePath)
        workoutManPath.append(bodyPath)
        workoutManPath.append(rightArmPath)
        workoutManPath.append(leftArmPath)
        workoutManPath.append(rightLegPath)
        workoutManPath.append(leftLegPath)
        
        workoutManPath.lineWidth = 3.0
        workoutManPath.lineCapStyle = .round
        
        fillColor.setStroke()
        workoutManPath.stroke()
    }


}

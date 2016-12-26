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
        circlePath.addArc(withCenter: CGPoint(x: 33, y: 21), radius: 4, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        fillColor.setFill()
        circlePath.fill()
        
        // Body
        let bodyPath = UIBezierPath()
        bodyPath.move(to: CGPoint(x: 31, y: 26))
        bodyPath.addLine(to: CGPoint(x: 23, y: 45))
        
        // Right arm
        let rightArmPath = UIBezierPath()
        rightArmPath.move(to: CGPoint(x: 31, y: 34))
        rightArmPath.addLine(to: CGPoint(x: 42, y: 40))
        
        // Left arm
        let leftArmPath = UIBezierPath()
        leftArmPath.move(to: CGPoint(x: 26, y: 33))
        leftArmPath.addLine(to: CGPoint(x: 16, y: 39))
        
        // Right leg
        let rightLegPath = UIBezierPath()
        rightLegPath.move(to: CGPoint(x: 24, y: 46))
        rightLegPath.addLine(to: CGPoint(x: 30, y: 55))
        rightLegPath.move(to: CGPoint(x: 30, y: 55))
        rightLegPath.addLine(to: CGPoint(x: 20, y: 65))
        
        // Left Leg
        let leftLegPath = UIBezierPath()
        leftLegPath.move(to: CGPoint(x: 23, y: 45))
        leftLegPath.addLine(to: CGPoint(x: 12, y: 66))
        
        let workoutManPath = UIBezierPath()
        workoutManPath.append(circlePath)
        workoutManPath.append(bodyPath)
        workoutManPath.append(rightArmPath)
        workoutManPath.append(leftArmPath)
        workoutManPath.append(rightLegPath)
        workoutManPath.append(leftLegPath)
        
        workoutManPath.lineWidth = 4.0
        workoutManPath.lineCapStyle = .round
        
        fillColor.setStroke()
        workoutManPath.stroke()
    }


}

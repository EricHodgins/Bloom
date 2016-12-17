//
//  CreateWorkoutButton.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-16.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

@IBDesignable
class CreateWorkoutButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    @IBInspectable var startColor: UIColor = UIColor.green
    @IBInspectable var endColor: UIColor = UIColor.white
    @IBInspectable var fillColor: UIColor = UIColor.green
    


    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: colorLocations)!
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.size.height)
        
        context!.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        
        // Draw the plus sign
        let plusPath = UIBezierPath()
        plusPath.lineWidth = 4.0
        
        // Vertical line
        plusPath.move(to: CGPoint(x: 25, y: 10))
        plusPath.addLine(to: CGPoint(x: 24, y: 40))
        
        // horizontal
        plusPath.move(to: CGPoint(x: 10, y: 25))
        plusPath.addLine(to: CGPoint(x: 40, y: 25))
        
        fillColor.setStroke()
        plusPath.stroke()
    }
    

}

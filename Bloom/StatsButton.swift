//
//  StatsButton.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-17.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

class StatsButton: GenericBloomButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let verticalPath = UIBezierPath()
        verticalPath.lineWidth = 4.0
        verticalPath.move(to: CGPoint(x: 8, y: 10))
        verticalPath.addLine(to: CGPoint(x: 8, y: 50))
        
        let horizontalPath = UIBezierPath()
        horizontalPath.lineWidth = 4.0
        horizontalPath.move(to: CGPoint(x: 8, y: 50))
        horizontalPath.addLine(to: CGPoint(x: 50, y: 50))
        
        // Line in graph
        let line1 = UIBezierPath()
        line1.lineWidth = 4.0
        line1.move(to: CGPoint(x: 15, y: 45))
        line1.addLine(to: CGPoint(x: 28, y: 30))
        
        line1.move(to: CGPoint(x: 28, y: 30))
        line1.addLine(to: CGPoint(x: 37, y: 40))
        
        line1.move(to: CGPoint(x: 37, y: 40))
        line1.addLine(to: CGPoint(x: 50, y: 15))
        
        let graphPath = UIBezierPath()
        graphPath.append(verticalPath)
        graphPath.append(horizontalPath)
        graphPath.append(line1)
        
        graphPath.lineWidth = 4.0
        graphPath.lineCapStyle = .round
        fillColor.setStroke()
        graphPath.stroke()
    }
 

}

//
//  GraphView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-05-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//


import UIKit

@IBDesignable
class GraphView: UIView {

    @IBInspectable var startColor: UIColor = UIColor.red
    @IBInspectable var endColor: UIColor = UIColor.green
    
    var dataSet: [Double] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //@IBInspectable var startUnderGraphColor: UIColor = UIColor.blue
    //@IBInspectable var endUnderGraphColor: UIColor = UIColor.white
    
    //testing
    var graphPoints: [Int] {
        var nums = [Int]()
        for i in 1...20 {
            nums.append(i*i*i)
        }
        return nums
    }
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        // Calculate X point
        let margin:CGFloat = 20.0
        let columnXPoint = { (column:Double) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin*2 - 4) /
                CGFloat((self.dataSet.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // Calculate Y Point
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = dataSet.max()!
        let minValue = dataSet.min()!
        let diff = maxValue - minValue
        let columnYPoint = { (graphPoint:Double) -> CGFloat in
            var y: CGFloat = ((CGFloat(graphPoint) - CGFloat(minValue)) / CGFloat(diff)) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        // draw the line graph
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        //set up the points line
        let graphPath = UIBezierPath()
        //go to start of line
        graphPath.move(to: CGPoint(x:columnXPoint(0),
                                   y:columnYPoint(dataSet[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<dataSet.count {
            let nextPoint = CGPoint(x:columnXPoint(Double(i)),
                                    y:columnYPoint(dataSet[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        //Create the clipping path for the graph gradient
        
        //1 - save the state of the context (commented out for now)
        context!.saveGState()
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(
            x: columnXPoint(Double(dataSet.count - 1)),
            y:height))
        clippingPath.addLine(to: CGPoint(
            x:columnXPoint(0),
            y:height))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        // Gradient under points
        let highestYPoint = columnYPoint(maxValue)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        context?.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        // Draw the circle points
        
        for i in 0..<dataSet.count {
            var point = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(dataSet[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        // Draw horizontal lines
        let linePath = UIBezierPath()
        
        // top line
        linePath.move(to: CGPoint(x: 0, y: 10))
        linePath.addLine(to: CGPoint(x: width, y: 10))
        
        // center line
        linePath.move(to: CGPoint(x: 0, y: (height - 20) / 2))
        linePath.addLine(to: CGPoint(x: width, y: (height - 20) / 2))
        
        // bottom line
        linePath.move(to: CGPoint(x: 0, y: height - 10))
        linePath.addLine(to: CGPoint(x: width, y: height - 10))
        
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    

}



























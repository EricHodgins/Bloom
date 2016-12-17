//: Playground - noun: a place where people can play

import UIKit


let size = CGSize(width: 400, height: 400)
let rect = CGRect(origin: .zero, size: size)


// MARK: - Draw the plus sign

let fillColor = UIColor.green

// Begin context

UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

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

let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
image
//: Playground - noun: a place where people can play

import UIKit


let size = CGSize(width: 400, height: 400)
let rect = CGRect(origin: .zero, size: size)


// MARK: - Draw the plus sign

let plusSignFillColor = UIColor.green

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

plusSignFillColor.setStroke()
plusPath.stroke()

let fullPlusSignPath = UIBezierPath()
fullPlusSignPath.append(plusPath)

let plusSignImage = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
plusSignImage


// MARK - Draw stick man

let stickManFillColor = UIColor.red

UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

// Head
let circlePath = UIBezierPath()
circlePath.addArc(withCenter: CGPoint(x: 33, y: 20), radius: 5, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)

stickManFillColor.setFill()
circlePath.fill()

// Body
let bodyPath = UIBezierPath()
bodyPath.lineWidth = 3.0
bodyPath.move(to: CGPoint(x: 31, y: 26))
bodyPath.addLine(to: CGPoint(x: 23, y: 45))
bodyPath.lineCapStyle = .round

stickManFillColor.setStroke()
bodyPath.stroke()

// Right arm
let rightArmPath = UIBezierPath()
rightArmPath.lineWidth = 3.0
rightArmPath.move(to: CGPoint(x: 31, y: 34))
rightArmPath.addLine(to: CGPoint(x: 44, y: 40))
rightArmPath.lineCapStyle = .round

stickManFillColor.setStroke()
rightArmPath.stroke()

// Left arm
let leftArmPath = UIBezierPath()
leftArmPath.lineWidth = 3.0
leftArmPath.move(to: CGPoint(x: 25, y: 32))
leftArmPath.addLine(to: CGPoint(x: 16, y: 39))
leftArmPath.lineCapStyle = .round

stickManFillColor.setStroke()
leftArmPath.stroke()

// Right leg
let rightLegPath = UIBezierPath()
rightLegPath.lineWidth = 3.0
rightLegPath.move(to: CGPoint(x: 24, y: 46))
rightLegPath.addLine(to: CGPoint(x: 30, y: 55))
rightLegPath.move(to: CGPoint(x: 30, y: 55))
rightLegPath.addLine(to: CGPoint(x: 20, y: 65))
rightLegPath.lineCapStyle = .round

stickManFillColor.setStroke()
rightLegPath.stroke()

// Left Leg
let leftLegPath = UIBezierPath()
leftLegPath.lineWidth = 3.0
leftLegPath.move(to: CGPoint(x: 22, y: 45))
leftLegPath.addLine(to: CGPoint(x: 12, y: 66))
leftLegPath.lineCapStyle = .round

stickManFillColor.setStroke()
leftLegPath.stroke()

let workoutManPath = UIBezierPath()
workoutManPath.append(circlePath)
workoutManPath.append(bodyPath)
workoutManPath.append(rightArmPath)
workoutManPath.append(leftArmPath)
workoutManPath.append(rightLegPath)
workoutManPath.append(leftLegPath)


let stickManImage = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
stickManImage







































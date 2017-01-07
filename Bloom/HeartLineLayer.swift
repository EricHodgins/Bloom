//
//  HeartLineLayer.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class HeartLineLayer: CALayer {
    fileprivate lazy var heartLine : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.opacity = 0.5
        layer.lineWidth = 2
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        return layer
    }()
    
    fileprivate lazy var heartLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.red.cgColor
        layer.lineJoin = kCALineJoinRound
        return layer
    }()
    
    override init() {
        super.init()
        sharedInit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        addSublayer(heartLine)
        addSublayer(heartLayer)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        if heartLine.bounds != bounds {
            heartLine.bounds = bounds
            heartLine.position = center
        }
    }
    
    func heartPath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: 23))
        path.addCurve(to: CGPoint(x:20, y:15), controlPoint1: CGPoint(x: 20, y:25), controlPoint2: CGPoint(x: 30, y: 10))
        
        path.move(to: CGPoint(x: 20, y: 23))
        
        path.addCurve(to: CGPoint(x: 20, y: 15), controlPoint1: CGPoint(x:20, y:25), controlPoint2: CGPoint(x:10, y: 10))
        path.close()
        
        return path.cgPath
    }
    
    func heartLinePath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.3, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.33, y: bounds.size.height*0.4))
        path.addLine(to: CGPoint(x: bounds.size.width*0.36, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.38, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.39, y: bounds.size.height*0.54))
        path.addLine(to: CGPoint(x: bounds.size.width*0.45, y: bounds.size.height*0.2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.55, y: bounds.size.height*0.7))
        path.addLine(to: CGPoint(x: bounds.size.width*0.60, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height/2))
        
        let heartBeatPath = UIBezierPath()
        heartBeatPath.append(path)
        return heartBeatPath.cgPath
    }
    
    func animateHeartLine() {
        heartLine.path = heartLinePath()
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeStartAnimation.fromValue = -5
        strokeStartAnimation.toValue = 1
        
        let lineWidthAnim = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnim.fromValue = 0
        lineWidthAnim.toValue = 2
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 2.0
        groupAnimation.repeatCount = .infinity
        groupAnimation.animations = [strokeEndAnimation, strokeStartAnimation, lineWidthAnim]
        
        heartLine.add(groupAnimation, forKey: nil)
    }
    
    func animateHeartPulse() {
        heartLayer.path = heartPath()
        heartLayer.frame.origin = CGPoint(x: 20, y: 15)
        heartLayer.bounds.origin = CGPoint(x: 20, y:20)
        let pulse = CAKeyframeAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulse.duration = 1.25
        pulse.repeatCount = .infinity
        pulse.values = [0.75, 0.95, 1, 1.5, 0.75]
        pulse.keyTimes = [0, 0.05, 0.4, 0.5, 0.7]
//        pulse.values = [0.75, 0.95, 1.25, 0.75]
//        pulse.keyTimes = [0, 0.75, 0.90, 1]
        
        heartLayer.add(pulse, forKey: nil)
        
//        let pulse = CAKeyframeAnimation(keyPath: "transform.scale")
//        pulse.duration = 1
//        pulse.repeatCount = .infinity
//        pulse.values = [0.5, 0.6, 0.62, 1, 0.5]
//        pulse.keyTimes = [0, 0.09, 0.4, 0.5, 0.7]
    }
}















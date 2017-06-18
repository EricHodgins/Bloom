//
//  HeartLineView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-18.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class HeartLineView: UIView {
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        heartLine.path = heartLinePath()
        layer.addSublayer(heartLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been initialized.")
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
    
    func animateLine() {
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
}










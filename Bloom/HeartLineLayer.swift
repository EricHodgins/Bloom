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
        layer.lineWidth = 4
        layer.lineCap = kCALineCapRound
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
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        if heartLine.bounds != bounds {
            heartLine.bounds = bounds
            heartLine.position = center
        }
        
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
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 1.5
        anim.repeatCount = .infinity
        
        let lineWidthAnim = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnim.fromValue = 0
        lineWidthAnim.toValue = 4
        lineWidthAnim.duration = 1.5
        lineWidthAnim.repeatCount = .infinity
        
        heartLine.add(anim, forKey: nil)
        heartLine.add(lineWidthAnim, forKey: nil)
    }
}

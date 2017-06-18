//
//  HeartView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-18.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit


class HeartView: UIView {
    
    private var lineWidth: CGFloat = 1.0
    
    fileprivate lazy var heartLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.red.cgColor
        layer.opacity = 1.0
        layer.lineWidth = self.lineWidth
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        heartLayer.path = heartPath()
        layer.addSublayer(heartLayer)
        
        let gradient = CAGradientLayer()
        gradient.frame = heartPath().boundingBox
        gradient.bounds = heartPath().boundingBox
        gradient.colors = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor]
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = heartPath()
        gradient.mask = shapeMask
        
        
        heartLayer.addSublayer(gradient)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func heartPath() -> CGPath {
        let path = UIBezierPath()
        
        let margin: CGFloat = lineWidth
        let middleTop = CGPoint(x: frame.width / 2, y: margin + 4/30*frame.height)//40
        let middleBottom = CGPoint(x: frame.width/2, y: frame.height - margin - margin)
        
        let c1 = CGPoint(x: frame.width + 5/30*frame.width, y: -0.25*frame.height)//50, -75
        let c2 = CGPoint(x: frame.width + 4/30*frame.width, y: frame.height - 1/3*frame.height)
        
        let c3 = CGPoint(x: -5/30*frame.width, y: -0.25*frame.height)//-50, -75
        let c4 = CGPoint(x: -4/30*frame.width, y: frame.height - 1/3*frame.height)
        
        path.move(to: middleTop)
        path.addCurve(to: middleBottom, controlPoint1: c1, controlPoint2: c2)
        path.close()
        
        path.move(to: middleTop)
        path.addCurve(to: middleBottom, controlPoint1: c3, controlPoint2: c4)
        path.close()
        
        return path.cgPath
    }
    
    func pulse() {
        heartLayer.frame.origin = CGPoint(x: frame.width/2, y: frame.height/2)
        heartLayer.bounds.origin = CGPoint(x: frame.width/2, y:frame.height/2)
        
        let pulse = CAKeyframeAnimation(keyPath: "transform.scale")
        pulse.duration = 1
        pulse.repeatCount = .infinity
        pulse.values = [0.5, 0.6, 0.62, 1, 0.5]
        pulse.keyTimes = [0, 0.09, 0.4, 0.5, 0.7]
        
        heartLayer.add(pulse, forKey: nil)
        
    }

}

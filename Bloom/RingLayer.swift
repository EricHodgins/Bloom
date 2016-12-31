//
//  RingLayer.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-30.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

public class RingLayer: CALayer {
    
    fileprivate let angleOffsetForZero = CGFloat(-M_PI_2)
    
    //:- Layers
    // - backgroundLayer is not used.  But keeping for now incase needed later.
    fileprivate lazy var backgroundLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = self.ringBackgroundColor
        layer.lineWidth = self.ringWidth
        layer.fillColor = nil
        return layer
    }()
    
    fileprivate lazy var gradientLayer : CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        let colors = self.ringGradientColors
        layer.colors = colors
        let locations: [NSNumber] = [0, 1.0]
        layer.locations = locations
        
        return layer
    }()
    
    fileprivate lazy var foregroundLayer : CALayer = {
        let layer = CALayer()
        layer.addSublayer(self.gradientLayer)
        layer.mask = self.foregroundMask
        return layer
    }()
    
    fileprivate lazy var foregroundMask : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = self.ringWidth
        layer.lineCap = kCALineCapRound
        return layer
    }()
    
    
    // Public API
    var value: CGFloat = 0.0
    var ringBackgroundColor: CGColor = UIColor.darkGray.cgColor // not used
    var ringGradientColors: [CGColor] = [UIColor.blue.cgColor, UIColor.red.cgColor] {
        didSet {
            gradientLayer.colors = ringGradientColors
            
        }
    }
    var ringWidth: CGFloat = 6 {
        didSet {
            foregroundMask.lineWidth = ringWidth
        }
    }
    
    override init() {
        super.init()
        sharedInitialization()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
}

extension RingLayer {
    fileprivate func sharedInitialization() {
        backgroundColor = UIColor.clear.cgColor
        addSublayer(foregroundLayer)
        self.value = 1.0
    }
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        if backgroundLayer.bounds != bounds {
            for layer in [foregroundLayer, gradientLayer, foregroundMask] {
                layer.bounds = bounds
                layer.position = center
            }
            
            preparePaths()
        }
    }
}

extension RingLayer {
    fileprivate var radius: CGFloat {
        return (min(bounds.width, bounds.height) - ringWidth) / 2.0
    }
    
    fileprivate func maskPath(value: CGFloat) -> CGPath {
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: angleOffsetForZero, endAngle: angle(value: value), clockwise: true).cgPath
    }
    
    fileprivate func angle(value: CGFloat) -> CGFloat {
        return value * 2 * CGFloat(M_PI) + angleOffsetForZero
    }
    
    fileprivate var backgroundPath: CGPath {
        return maskPath(value: 1)
    }
    
    fileprivate func preparePaths() {
        backgroundLayer.path = backgroundPath
        foregroundMask.path = maskPath(value: value)
    }
    
    
    // MARK: - Animations
    func animateGradientPath(withSeconds seconds: Int) {
        foregroundMask.path = maskPath(value: value)
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0
        anim.toValue = 1.0
        anim.duration = CFTimeInterval(seconds)
        
        foregroundMask.add(anim, forKey: nil)
    }
}

//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


public class RingLayer : CALayer {
    
    fileprivate let angleOffsetForZero = CGFloat(-M_PI_2)
    
    //:- Layers
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
        let colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
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
    
    // API
    var value: CGFloat = 0.8
    var ringBackgroundColor: CGColor = UIColor.darkGray.cgColor
    var ringWidth: CGFloat = 40.0
    
    override init() {
        super.init()
        sharedInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
}

extension RingLayer {
    fileprivate func sharedInitialization() {
        backgroundColor = UIColor.black.cgColor
        addSublayer(backgroundLayer)
        addSublayer(foregroundLayer)
        self.value = 1.0
    }
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        if backgroundLayer.bounds != bounds {
            for layer in [backgroundLayer, foregroundLayer, gradientLayer, foregroundMask] {
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
    }
    
    func animateGradientPath() {
        foregroundMask.path = maskPath(value: value)
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0
        anim.toValue = 1.1
        anim.duration = 3.0
        
        foregroundMask.add(anim, forKey: nil)
    }
}


let ring = RingLayer()
viewWithLayer(layer: ring)
ring.animateGradientPath()


PlaygroundPage.current.liveView = viewWithLayer(layer: ring)










































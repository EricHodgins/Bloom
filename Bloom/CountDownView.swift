//
//  CountDownView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-26.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

let π = CGFloat(M_PI)

@IBDesignable
class CountDownView: UIView {
    
    @IBInspectable var strokeColor: UIColor = UIColor.blue
    
    let circleShapeLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func setup() {
        layer.addSublayer(circleShapeLayer)
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let margin:CGFloat = 16
        let radius = min(bounds.size.height, bounds.size.width) - margin
        let outerOvalOrigin: CGFloat = bounds.size.width/2 - radius/2
        let outerOval = CGRect(x: outerOvalOrigin, y: margin/2, width: radius, height: radius)
        let outerCircle = UIBezierPath(ovalIn: outerOval)
        
        circleShapeLayer.path = outerCircle.cgPath
        circleShapeLayer.lineWidth = 15.0
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.strokeColor = strokeColor.cgColor
        layer.addSublayer(circleShapeLayer)
    }
    
    func animateCircleDrawn() {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.duration = 0.5
        
        circleShapeLayer.add(strokeAnimation, forKey: nil)
    }
}
















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
    var countDownLabel: UILabel!
    
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
        circleShapeLayer.lineDashPattern = [40, 3]
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.strokeColor = strokeColor.cgColor
        layer.addSublayer(circleShapeLayer)
    }
    
    func animateCircleDrawn() {
        
        startCountDown(withSeconds: 3)
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.delegate = self
        strokeAnimation.setValue(circleShapeLayer, forKey: "strokeCircleOn")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.duration = 3
        
        circleShapeLayer.add(strokeAnimation, forKey: nil)
    }
    
    func animateCircleOff(withSeconds seconds: CFTimeInterval) {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeAnimation.delegate = self
        strokeAnimation.setValue(circleShapeLayer, forKey: "strokeCircleOff")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.fillMode = kCAFillModeForwards
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.duration = seconds
        
        circleShapeLayer.add(strokeAnimation, forKey: nil)
    }
    
    func startCountDown(withSeconds seconds: Int) {
        var timeRemaining = seconds
        countDownLabel.text = "\(timeRemaining)"
        timeRemaining = timeRemaining - 1
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            DispatchQueue.main.async {
                self.countDownLabel.text = "\(timeRemaining)"
                timeRemaining = timeRemaining - 1
                if timeRemaining == -1 {
                    timer.invalidate()
                }
            }
        }
    }
}

extension CountDownView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let _ = anim.value(forKey: "strokeCircleOn") as? CAShapeLayer{
            animateCircleOff(withSeconds: 0.5)
            return
        }
        
        if let _ = anim.value(forKey: "strokeCircleOff") as? CAShapeLayer {
            circleShapeLayer.strokeColor = UIColor.clear.cgColor
            return
        }
    }
}














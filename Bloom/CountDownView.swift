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
    let ringLayer = RingLayer()
    
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
        layer.addSublayer(ringLayer)
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        ringLayer.frame = bounds
        
        
    }
    
    
    func startCountDown(withSeconds seconds: Int) {
        var timeRemaining = seconds
        //countDownLabel.text = "\(timeRemaining)"
        timeRemaining = timeRemaining - 1
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            DispatchQueue.main.async {
                //self.countDownLabel.text = "\(timeRemaining)"
                timeRemaining = timeRemaining - 1
                if timeRemaining == -1 {
                    timer.invalidate()
                }
            }
        }
    }
    
}

extension CountDownView: CAAnimationDelegate {
    
    func animateRing() {
        ringLayer.animateGradientPath()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if let _ = anim.value(forKey: "strokeCircleOn") as? CAShapeLayer{
//            animateCircleOff(withSeconds: 0.5)
//            return
//        }
//        
//        if let _ = anim.value(forKey: "strokeCircleOff") as? CAShapeLayer {
//            circleShapeLayer.strokeColor = UIColor.clear.cgColor
//            return
//        }
    }
}














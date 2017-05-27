//
//  CountDownView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-26.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

let π = CGFloat(Double.pi)

@IBDesignable
class CountDownView: UIView {
    
    @IBInspectable var ringGradientStarColor: UIColor = UIColor.blue
    @IBInspectable var ringGradientEndColor: UIColor = UIColor.red
    
    fileprivate lazy var ringLayer: RingLayer = {
        let layer = RingLayer()
        layer.ringGradientColors = [self.ringGradientStarColor.cgColor, self.ringGradientEndColor.cgColor]
        layer.ringWidth = 15.0
        return layer
    }()
    
    weak var delegate: CountDown!
    var countDownLabel: UILabel!
    
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
        countDownLabel.text = "\(timeRemaining)"
        timeRemaining = timeRemaining - 1
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            DispatchQueue.main.async { [unowned self] in
                self.countDownLabel.text = "\(timeRemaining)"
                timeRemaining = timeRemaining - 1
                if timeRemaining == -1 {
                    timer.invalidate()
                    self.delegate.countDownComplete()
                }
            }
        }
    }
    
}

extension CountDownView {
    
    func animateRing(withSeconds seconds: Int) {
        ringLayer.animateGradientPath(withSeconds: seconds)
    }
    
}














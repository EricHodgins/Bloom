//
//  HeartBeatView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

@IBDesignable
class HeartBeatView: UIView {
    
    fileprivate var heartLineView: HeartLineView!
    fileprivate var heartView: HeartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //heartLineLayer.frame = bounds
    }
    
    private func setup() {
        heartLineView = HeartLineView(frame: bounds)
        addSubview(heartLineView)
        
        heartView = HeartView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        addSubview(heartView)
        //layer.insertSublayer(heartLineLayer, above: layer)
        //layer.masksToBounds = true
    }
    
    func startAnimatingHeartLine() {
        heartLineView.animateLine()
        heartView.pulse(speed: .fast)
        //heartLineLayer.animateHeartLine()
        //heartLineLayer.animateHeartPulse()
    }

}

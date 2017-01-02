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
    
    fileprivate lazy var heartLineLayer: HeartLineLayer = {
        let layer = HeartLineLayer()
        return layer
    }()
    
    
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
        heartLineLayer.frame = bounds
    }
    
    func setup() {
        layer.insertSublayer(heartLineLayer, above: layer)
        layer.masksToBounds = true
    }
    
    func startAnimatingHeartLine() {
        heartLineLayer.animateHeartLine()
    }

}

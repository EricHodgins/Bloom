//
//  GenericBloomButton.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-17.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class GenericBloomButton: UIButton {
    
    var context: CGContext?
    @IBInspectable var startColor: UIColor = UIColor.green
    @IBInspectable var endColor: UIColor = UIColor.white
    @IBInspectable var fillColor: UIColor = UIColor.green
    
    let gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        layer.masksToBounds = true
        layer.cornerRadius = 20
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        let colors = [self.startColor.cgColor, self.endColor.cgColor]
        gradientLayer.colors = colors
        let locations: [NSNumber] = [0, 1]
        gradientLayer.locations = locations
        
        gradientLayer.frame = bounds
        
    }
    
}

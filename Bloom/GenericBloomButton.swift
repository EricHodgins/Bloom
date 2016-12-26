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
//        context = UIGraphicsGetCurrentContext()
//        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let colorLocations: [CGFloat] = [0.0, 1.0]
//        
//        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: colorLocations)!
//        let startPoint = CGPoint.zero
//        let endPoint = CGPoint(x: 0, y: bounds.size.height)
//        
//        context!.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
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
        layer.addSublayer(gradientLayer)
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

//
//  StartButton.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-25.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

class StartButton: GenericBloomButton {
    
    @IBInspectable var startNewGradientColor: UIColor = UIColor.blue
    @IBInspectable var endNewGradientColor: UIColor = UIColor.white

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setup() {
        super.setup()
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 20
    }
    
    //MARK: - Animations
    func animateGradient() {
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.fromValue = [startColor.cgColor, endColor.cgColor]
        gradientAnimation.toValue = [startNewGradientColor.cgColor, endNewGradientColor.cgColor]
        gradientAnimation.duration = 5.0
        
        
    }
}

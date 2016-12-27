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
    
    var editWorkoutButton: EditWorkoutButton!
    var buttonAnimationCompletion: (() -> Void)?

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
        editWorkoutButton.animateGradient()
        
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.setValue(gradientLayer, forKey: "gradientLayer")
        gradientAnimation.fromValue = [startColor.cgColor, endColor.cgColor]
        gradientAnimation.toValue = [startNewGradientColor.cgColor, endNewGradientColor.cgColor]
        gradientAnimation.delegate = self
        gradientAnimation.duration = 0.5
        gradientAnimation.fillMode = kCAFillModeForwards
        gradientAnimation.isRemovedOnCompletion = false
        
        gradientLayer.add(gradientAnimation, forKey: nil)
    }
    
}

extension StartButton: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let _ = anim.value(forKey: "gradientLayer") as? CAGradientLayer else { return }
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1.0, animations: {
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            
        }, completion: {_ in
            //self.removeFromSuperview()
            self.isHidden = true
            self.buttonAnimationCompletion!()
        })
    }
    
}






















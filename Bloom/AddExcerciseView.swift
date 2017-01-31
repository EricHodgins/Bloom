//
//  AddExcerciseView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-19.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit


class AddExcerciseView: BaseBloomView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        textField.delegate = self

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}


extension AddExcerciseView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func savePressed() {
        if textField.text != "" {
            completionHandler!(textField.text!)
            removeViewFromSuperViewAnimation()
        }
    }
    
    func cancelPressed() {
        completionHandler!(nil)
        removeViewFromSuperViewAnimation()
    }
    
    func removeViewFromSuperViewAnimation() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1.0, animations: {
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            
        }, completion: {_ in
            self.removeFromSuperview()
        })
    }
}


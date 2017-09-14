//
//  BloomTextfieldManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-09-13.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class BloomTextfieldManager {
    public var enabled: Bool {
        didSet {
            if enabled == true {
                registerForKeyboardNotifications()
            } else {
                removeNotifications()
            }
        }
    }
    
    public var viewToMove: UIView? = nil {
        didSet {
            guard viewToMove != nil else { return }
            self.initialYOrigin = viewToMove!.frame.origin.y
        }
    }
    private var initialYOrigin: CGFloat = 0
    
    static let shared = BloomTextfieldManager()
    private init() {
        enabled = false
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(BloomTextfieldManager.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BloomTextfieldManager.keyboardWasHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo!
        let endheight = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        
        animateViewUp(keyboardHeight: endheight!)
    }
    
    @objc private func keyboardWasHidden(notification: Notification) {
        animateViewBackToOrigin()
    }
    
    private func animateViewUp(keyboardHeight height: CGFloat) {
        let window = UIApplication.shared.keyWindow!
        let v = window.subviews.last!
        
        // If there's a specific view to move, move this one
        if let view = viewToMove {
            UIView.animate(withDuration: 0.3, animations: {
                view.frame.origin.y = view.superview!.frame.height - height - view.frame.height
            })
            return
        }
        
        //Otherwise just move the first view (bottom)
        let textfield = findTextfield(subviews: window.subviews)
        guard textfield != nil else { return }
        
        let keyboardTop = v.frame.height - height
        let buttonHeight = v.frame.height * 0.1
        if (textfield!.frame.origin.y + buttonHeight ) > keyboardTop {
            UIView.animate(withDuration: 0.3) {
                v.frame.origin.y = v.frame.height - height - textfield!.frame.origin.y - 60 - buttonHeight
            }
        }
    }
    
    private func findTextfield(subviews: [UIView]) -> UITextField? {
        for view in subviews {
            if type(of: view) == UITextField.self {
                return view as? UITextField
            }
            
            let textfield = findTextfield(subviews: view.subviews)
            if textfield != nil {
                return textfield
            }
        }
        return nil
    }
    
    private func animateViewBackToOrigin() {
        let window = UIApplication.shared.keyWindow!
        let v = window.subviews.last!
        
        if let view = viewToMove {
            UIView.animate(withDuration: 0.3, animations: { 
                view.frame.origin.y = self.initialYOrigin
            })
            viewToMove = nil
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            v.frame.origin.y = 0
        }, completion: nil)
    }
}

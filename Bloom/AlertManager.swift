//
//  AlertManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-26.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class AlertManager {
    
    static func alert(title: String, message: String, style: UIAlertControllerStyle) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        
        return alertController
    }
}

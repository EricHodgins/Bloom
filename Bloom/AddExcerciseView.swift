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
}


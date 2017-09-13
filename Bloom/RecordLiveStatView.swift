//
//  RecordLiveStatView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class RecordLiveStatView: BaseBloomView {
    
    var stat: Stat?
    
    var title: UILabel!
    var plusButton: UIButton!
    var minusButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.keyboardType = .decimalPad
        textField.delegate = self
        
        title = UILabel(frame: .zero)
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        
        plusButton = UIButton(frame: .zero)
        minusButton = UIButton(frame: .zero)
        
        setupTitleLabel()
        setupPlusButton()
        setupMinusButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitleLabel() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "TITLE"
        title.textAlignment = .center
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }
    
    func setupPlusButton() {
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setTitleColor(UIColor.blue, for: .normal)
        plusButton.backgroundColor = UIColor.clear
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
        plusButton.layer.cornerRadius = 10
        plusButton.layer.borderWidth = 1.0
        plusButton.layer.borderColor = UIColor.blue.cgColor
        addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 15),
            plusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            plusButton.widthAnchor.constraint(equalToConstant: 60),
            plusButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupMinusButton() {
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.setTitleColor(UIColor.blue, for: .normal)
        minusButton.backgroundColor = UIColor.clear
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
        minusButton.layer.cornerRadius = 10
        minusButton.layer.borderWidth = 1.0
        minusButton.layer.borderColor = UIColor.blue.cgColor
        addSubview(minusButton)
        
        NSLayoutConstraint.activate([
            minusButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 15),
            minusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            minusButton.widthAnchor.constraint(equalToConstant: 60),
            minusButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    
}

extension RecordLiveStatView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}

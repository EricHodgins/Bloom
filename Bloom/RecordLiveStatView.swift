//
//  RecordLiveStatView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-30.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class RecordLiveStatView: BaseBloomView {
    
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.delegate = self
        
        title = UILabel(frame: .zero)
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        setupTitleLabel()
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
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: 10)
        ])
        
    }
}

extension RecordLiveStatView: UITextFieldDelegate {
    
}

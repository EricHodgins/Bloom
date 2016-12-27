//
//  EditWorkoutButton.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-26.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

class EditWorkoutButton: GenericBloomButton {


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
    
    override func setup() {
        super.setup()
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 20
    }

}

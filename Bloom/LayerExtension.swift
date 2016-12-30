//
//  LayerExtension.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-30.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit

public extension CALayer {
    public var center: CGPoint {
        return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
}

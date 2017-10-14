//
//  Scene.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-10-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import MetalKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
    }
}


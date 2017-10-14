//
//  StartWorkoutScene.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-10-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import MetalKit

class StartWorkoutScene: Scene {
    var quad: Plane
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device, size: size)
        super.init(device: device, size: size)
        add(childNode: quad)
    }
}

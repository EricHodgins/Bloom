//
//  Node.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-10-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import MetalKit

class Node {
    var name: String = "Unititled"
    var children: [Node] = []
    
    func add(childNode: Node) {
        self.children.append(childNode)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        for child in children {
            child.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        }
    }
}

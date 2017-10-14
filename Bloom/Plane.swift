//
//  Plane.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-10-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import MetalKit

class Plane: Node {
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var vertices: [Vertex] = [
        Vertex(position: float3(-1, -1, 0), color: float4(1, 0, 0, 1)),
        Vertex(position: float3(-1, 1, 0), color: float4(0, 1, 0, 1)),
        Vertex(position: float3(1, -1, 0), color: float4(0, 0, 1, 1)),
        Vertex(position: float3(1, 1, 0), color: float4(1, 0, 1, 1)),
        ]
    
    var indices: [UInt16] = [
        0, 1, 2,
        2, 1, 3
    ]
    
    var time: Float = 0
    
    struct Constants {
        var animateBy: Float = 0
        var time: Float = 0
        var resolution: float2 = float2(x: 0, y: 0)
    }
    var constants = Constants()
    
    var size: CGSize
    init(device: MTLDevice, size: CGSize) {
        self.size = size
        let pixelWidth: Float = Float(UIScreen.main.scale * self.size.width)
        let pixelHeight: Float = Float(UIScreen.main.scale * self.size.height)
        constants.resolution = float2(x: pixelWidth, y: pixelHeight)
        super.init()
        buildBuffers(device: device)
    }
    
    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.size, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        guard let indexBuffer = indexBuffer else { return }
        
        time += deltaTime
        
        let animateBy = abs(sin(time) / 2 + 0.5)
        constants.animateBy = animateBy
        constants.time = time
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        commandEncoder.setFragmentBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
    }
}








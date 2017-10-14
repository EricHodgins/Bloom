//
//  Renderer.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-10-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var scene: Scene?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        super.init()
        buildPipelineState()
    }
    
    private func buildPipelineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let pipelineState = pipelineState,
            let descriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        commandEncoder.setRenderPipelineState(pipelineState)
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        scene?.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}


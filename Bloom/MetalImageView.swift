//
//  MetalImageView.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

/*
import MetalKit

class MetalImageView: MTKView {
    
    var image: CIImage?
    
    lazy var ciContext: CIContext = {
        let context = CIContext()
        return CIContext(mtlDevice: self.device!)
    }()
    
    lazy var commandQueue: MTLCommandQueue = {
        return self.device!.makeCommandQueue()
    }()
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device ?? MTLCreateSystemDefaultDevice())
        
        if super.device == nil {
            fatalError("Device not supported.")
        }

        framebufferOnly = false // Allows to write to the View's texture.
        
    }
    
    
}
*/



































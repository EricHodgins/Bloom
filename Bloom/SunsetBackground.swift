//
//  SunsetBackground.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-29.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//


import MetalKit

class SunsetBackground: MetalImageView {
    
    var timeTracker: Double = 0.0
    var positionTracker: CGFloat = 0.0
    var sunRadius: CGFloat = 70.0
    
    private let view: UIView!
    
    private lazy var beamFilter: CIFilter = {
        let filter = CIFilter(name: "CISunbeamsGenerator")!
        filter.setValue(self.sunRadius, forKeyPath: "inputSunRadius")
        filter.setValue(20, forKey: "inputMaxStriationRadius")
        filter.setValue(0.03, forKey: "inputStriationStrength")
        
        return filter
    }()
    
    private lazy var additionFilter: CIFilter = {
        return CIFilter(name: "CIAdditionCompositing")!
    }()
    
    private lazy var backgroundImage: CIImage = {
        let linearGradient = CIFilter(name: "CILinearGradient")!
        let input2 = CIVector.pixelPointForTopLeft(view: self.view)
        let input1 = CIVector.pixelPointForBottomRight(view: self.view)
        let color1 = CIColor(red: 0.5, green: 0.2, blue: 0.6, alpha: 1)
        let color2 = CIColor.black()
        linearGradient.setValue(input1, forKey: "inputPoint0")
        linearGradient.setValue(input2, forKey: "inputPoint1")
        linearGradient.setValue(color1, forKey: "inputColor0")
        linearGradient.setValue(color2, forKey: "inputColor1")
        return linearGradient.outputImage!
    }()
    
    
    init(frame frameRect: CGRect, device: MTLDevice?, withView view: UIView) {
        self.view = view
        super.init(frame: frameRect, device: device)
        updateImage()
        delegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func additionFilterImage(inputImage: CIImage) -> CIImage {
        additionFilter.setValue(inputImage, forKey: "inputImage")
        additionFilter.setValue(backgroundImage, forKey: "inputBackgroundImage")
        
        return additionFilter.outputImage!
    }
    
    func updateImage() {
        timeTracker += 0.00008
        positionTracker = (view.bounds.width / 2) * UIScreen.main.scale
        let bottom = -(view.bounds.height + 20) * UIScreen.main.scale
        sunRadius += 0.0
        beamFilter.setValue(sunRadius, forKeyPath: "inputSunRadius")
        beamFilter.setValue(timeTracker, forKey: kCIInputTimeKey)
        beamFilter.setValue(CIVector(x: positionTracker, y: bottom), forKeyPath: "inputCenter")
        
        image = additionFilterImage(inputImage: beamFilter.outputImage!)
    }
    
}


extension SunsetBackground: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = currentDrawable,
            let image = image,
            let targetTexture = currentDrawable?.texture else { return }
        
        let bounds = CGRect(origin: .zero, size: drawableSize)
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        updateImage()
        
        let translatedImage = image.applying(CGAffineTransform(translationX: 0, y: drawableSize.height))
        
        ciContext.render(translatedImage, to: targetTexture, commandBuffer: commandBuffer, bounds: bounds, colorSpace: colorSpace)
        
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}



extension CIVector {
    
    class func pixelPointForTopLeft(view: UIView) -> CIVector {
        let x: CGFloat = 0
        let y: CGFloat = 0//view.frame.height * UIScreen.main.scale * 0.75
        let point = CGPoint(x: x, y: y)
        
        return CIVector(cgPoint: point)
    }
    
    class func pixelPointForBottomRight(view: UIView) -> CIVector {
        let x = view.frame.width * UIScreen.main.scale * 1
        let y: CGFloat = view.frame.height * UIScreen.main.scale * 0.4
        let point = CGPoint(x: x, y: y)
        
        return CIVector(cgPoint: point)
    }
}


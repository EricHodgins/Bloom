//
//  FinishLiveWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-07.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import MetalKit

class FinishLiveWorkoutController: UIViewController {
    
    var timeTracker: Double = 0.0
    var positionTracker: CGFloat = 0.0
    var displayLink = CADisplayLink()
    
    lazy var metalView: MetalImageView = {
        let view = MetalImageView(frame: self.view.bounds, device: nil)
        return view
    }()
    
    private lazy var beamFilter: CIFilter = {
        let filter = CIFilter(name: "CISunbeamsGenerator")!
        filter.setValue(70, forKeyPath: "inputSunRadius")
        filter.setValue(8, forKey: "inputMaxStriationRadius")
        filter.setValue(0.1, forKey: "inputStriationStrength")
        
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


    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(metalView, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func testAnimation(_ sender: Any) {
        startAnimatingSunbeam()
    }
    func startAnimatingSunbeam() {
        displayLink = CADisplayLink(target: self, selector: #selector(FinishLiveWorkoutController.animate(displayLink:)))
        displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }
    
    func animate(displayLink: CADisplayLink) {
        timeTracker += 0.00008
        positionTracker += 0.05
        beamFilter.setValue(timeTracker, forKey: kCIInputTimeKey)
        beamFilter.setValue(CIVector(x: positionTracker, y: -positionTracker), forKeyPath: "inputCenter")
        metalView.image = additionFilterImage(inputImage: beamFilter.outputImage!)
    }
    
    private func additionFilterImage(inputImage: CIImage) -> CIImage {
        additionFilter.setValue(inputImage, forKey: "inputImage")
        additionFilter.setValue(backgroundImage, forKey: "inputBackgroundImage")
        
        return additionFilter.outputImage!
    }

}

extension CIVector {
    
    class func pixelPointForTopLeft(view: UIView) -> CIVector {
        let x: CGFloat = 0
        let y: CGFloat = view.frame.height * UIScreen.main.scale
        let point = CGPoint(x: x, y: y)
        
        return CIVector(cgPoint: point)
    }
    
    class func pixelPointForBottomRight(view: UIView) -> CIVector {
        let x = view.frame.width * UIScreen.main.scale
        let y: CGFloat = view.frame.height * UIScreen.main.scale
        let point = CGPoint(x: x, y: y)
        
        return CIVector(cgPoint: point)
    }
}























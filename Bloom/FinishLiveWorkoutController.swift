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
        filter.setValue(100, forKeyPath: "inputSunRadius")
        filter.setValue(10, forKey: "inputMaxStriationRadius")
        filter.setValue(0.2, forKey: "inputStriationStrength")
        
        return filter
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
        timeTracker += 0.0001
        positionTracker += 0.05
        beamFilter.setValue(timeTracker, forKey: kCIInputTimeKey)
        beamFilter.setValue(CIVector(x: positionTracker, y: positionTracker), forKeyPath: "inputCenter")
        metalView.image = beamFilter.outputImage!
        
    }

}

























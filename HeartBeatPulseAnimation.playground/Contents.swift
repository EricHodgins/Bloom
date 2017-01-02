//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

func addGradientLayer(toView view: UIView, belowLayer layer: CALayer) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    
    let colors = [UIColor.orange.cgColor, UIColor.yellow.cgColor]
    gradientLayer.colors = colors
    //let locations: [NSNumber] = [0, 0.5]
    //gradientLayer.locations = locations
    
    gradientLayer.frame = view.frame
    
    view.layer.insertSublayer(gradientLayer, below: layer)
}

func viewWithLayer(layer: CALayer, size: CGSize = CGSize(width: 600, height: 300)) -> UIView {
    let view = UIView(frame: CGRect(origin: .zero, size: size))
    view.backgroundColor = UIColor.black
    layer.bounds = view.bounds
    layer.position = view.center
    view.layer.addSublayer(layer)
    
    return view
}

class HeatBeatLayer: CALayer {
    
    fileprivate lazy var heartLine : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.opacity = 0.5
        layer.lineWidth = 8
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        return layer
    }()
    
    override init() {
       super.init()
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        addSublayer(heartLine)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
    }
    
    func heartLinePath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.3, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.33, y: bounds.size.height*0.4))
        path.addLine(to: CGPoint(x: bounds.size.width*0.36, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.38, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.39, y: bounds.size.height*0.54))
        path.addLine(to: CGPoint(x: bounds.size.width*0.45, y: bounds.size.height*0.2))
        path.addLine(to: CGPoint(x: bounds.size.width*0.55, y: bounds.size.height*0.7))
        path.addLine(to: CGPoint(x: bounds.size.width*0.60, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height/2))
        
        let heartBeatPath = UIBezierPath()
        heartBeatPath.append(path)
        return heartBeatPath.cgPath
    }
    
    func animateHeartLine() {
        heartLine.path = heartLinePath()
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 1.5
        anim.repeatCount = 5
        
        let lineWidthAnim = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnim.fromValue = 0
        lineWidthAnim.toValue = 8
        lineWidthAnim.duration = 1.5
        lineWidthAnim.repeatCount = 5
        
        heartLine.add(anim, forKey: nil)
        heartLine.add(lineWidthAnim, forKey: nil)
    }
}




let hearBeat = HeatBeatLayer()
let view = viewWithLayer(layer: hearBeat)
view



hearBeat.animateHeartLine()
PlaygroundPage.current.liveView = view

addGradientLayer(toView: view, belowLayer: hearBeat)



























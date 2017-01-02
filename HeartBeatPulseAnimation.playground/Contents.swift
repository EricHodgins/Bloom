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
    
    fileprivate lazy var heartLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.red.cgColor
        layer.lineJoin = kCALineJoinRound
        return layer
    }()
    
    
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
        addSublayer(heartLayer)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
    }
    
    func heartPath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 100, y: 100))
        path.addCurve(to: CGPoint(x:100, y:45), controlPoint1: CGPoint(x: 100, y:100), controlPoint2: CGPoint(x: 170, y: 25))
        
        path.move(to: CGPoint(x: 100, y: 100))
        
        path.addCurve(to: CGPoint(x: 100, y: 45), controlPoint1: CGPoint(x:100, y:100), controlPoint2: CGPoint(x:30, y: 25))
        path.close()
        
        return path.cgPath
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

        
        let anim2 = CABasicAnimation(keyPath: "strokeStart")
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim2.fromValue = -5
        anim2.toValue = 1.0

        
        let lineWidthAnim = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnim.fromValue = 0
        lineWidthAnim.toValue = 8

        
        
        let group = CAAnimationGroup()
        group.duration = 1.5
        group.repeatCount = 10
        group.animations = [anim, anim2, lineWidthAnim]
        
        heartLine.add(group, forKey: nil)
    }
    
    func animateHeartPulse() {
        heartLayer.path = heartPath()
        heartLayer.frame.origin = CGPoint(x: 75, y: 50)
        heartLayer.bounds.origin = CGPoint(x: 100, y:60)
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.fromValue = 0.5
        anim.toValue = 1.25
        anim.duration = 1
        anim.repeatCount = 10
        anim.autoreverses = true
        
        heartLayer.add(anim, forKey: nil)
    }
}




let hearBeat = HeatBeatLayer()
let view = viewWithLayer(layer: hearBeat)
view



hearBeat.animateHeartLine()
hearBeat.animateHeartPulse()
PlaygroundPage.current.liveView = view

addGradientLayer(toView: view, belowLayer: hearBeat)



























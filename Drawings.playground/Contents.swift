//: Playground - noun: a place where people can play

import UIKit

let π = CGFloat(M_PI)
let size = CGSize(width: 400, height: 400)
let rect = CGRect(x: 0, y: 0, width: 400, height: 400)

extension UIView {
    func drawGradient(startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
}

class CustomView: UIView {
    
    let arcLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(arcLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let centerPoint = CGPoint(x: frame.midX, y: frame.midY)
        let arcPath = UIBezierPath(arcCenter: centerPoint, radius: 180, startAngle: π, endAngle: 0, clockwise: true)
        arcPath.lineWidth = 20.0
        let curvedLinePath = arcPath.cgPath.copy(strokingWithWidth: arcPath.lineWidth, lineCap: arcPath.lineCapStyle, lineJoin: arcPath.lineJoinStyle, miterLimit: arcPath.miterLimit)
        
        let curvedPath = UIBezierPath(cgPath: curvedLinePath)

        curvedPath.addClip()
        
        drawGradient(startColor: UIColor.white, endColor: UIColor.purple, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: rect.width, y: rect.height))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = UIColor.black
    }
}

let customerView = CustomView(frame: rect)
customerView

//let view = UIView(frame: rect)
//view.backgroundColor = UIColor.white
//let centerPoint = CGPoint(x: view.frame.midX, y: view.frame.midY)
//
//let arcLinePath = UIBezierPath(arcCenter: centerPoint, radius: 180, startAngle: π, endAngle: 0, clockwise: true)
//arcLinePath.lineWidth = 20.0
//
//let newCopy = arcLinePath.cgPath.copy(strokingWithWidth: arcLinePath.lineWidth, lineCap: arcLinePath.lineCapStyle, lineJoin: arcLinePath.lineJoinStyle, miterLimit: arcLinePath.miterLimit)
//
//let newPath = UIBezierPath(cgPath: newCopy)
//UIColor.white.setFill()
//newPath.addClip()
//
//let circleLayer = CAShapeLayer()
//circleLayer.path = newPath.cgPath
//circleLayer.lineWidth = 20.0
//circleLayer.strokeColor = UIColor.blue.cgColor
//
//let gradientLayer = CAGradientLayer()
//gradientLayer.frame = view.frame
//gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//gradientLayer.colors = [UIColor.green.cgColor, UIColor.orange.cgColor]
//
//view.layer.addSublayer(circleLayer)
//view

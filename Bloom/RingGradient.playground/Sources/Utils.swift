import UIKit

public func viewWithLayer(layer: CALayer, size: CGSize = CGSize(width: 300, height: 300)) -> UIView {
    let view = UIView(frame: CGRect(origin: .zero, size: size))
    view.backgroundColor = UIColor.black
    layer.bounds = view.bounds
    layer.position = view.center
    view.layer.addSublayer(layer)
    return view
}

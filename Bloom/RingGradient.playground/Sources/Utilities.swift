import UIKit

public extension UIColor {
    public var darkerColor : UIColor {
        var hue : CGFloat = 0.0
        var saturation : CGFloat = 0.0
        var brightness : CGFloat = 0.0
        var alpha : CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: min(hue * 1.1, 1.0), saturation: saturation, brightness: brightness * 0.7, alpha: alpha)
    }
}

public extension CGColor {
    public var darkerColor : CGColor {
        let uiColor = UIColor(cgColor: self)
        return uiColor.darkerColor.cgColor
    }
}

public extension CALayer {
    public var center : CGPoint {
        return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
}

public extension UIColor {
    static var hrGreenColor : UIColor {
        return UIColor(red: 158.0/255.0, green: 255.0/255.0, blue:   9.0/255.0, alpha: 1.0)
    }
    
    static var hrBlueColor : UIColor {
        return UIColor(red:  33.0/255.0, green: 253.0/255.0, blue: 197.0/255.0, alpha: 1.0)
    }
    
    static var hrPinkColor : UIColor {
        return UIColor(red: 251.0/255.0, green:  12.0/255.0, blue: 116.0/255.0, alpha: 1.0)
    }
}


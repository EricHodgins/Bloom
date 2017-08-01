//
//  Utils.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-22.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit


extension String {
    var removeExtraWhiteSpace: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter({ (s) -> Bool in
            return !s.isEmpty
        }).joined(separator: " ")
    }
}

extension UIImage {
    static func gradientImageData(size: CGSize, topUIColor: UIColor, bottomUIColor: UIColor) -> Data {
        let topColor = CIColor(color: topUIColor)
        let bottomColor = CIColor(color: bottomUIColor)
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        
        let startVector: CIVector = CIVector(x: size.width * 0.5, y: 0)
        let endVector: CIVector = CIVector(x: size.width * 0.5, y: size.height)
        
        filter!.setValue(startVector, forKey: "inputPoint0")
        filter!.setValue(endVector, forKey: "inputPoint1")
        filter!.setValue(topColor, forKey: "inputColor0")
        filter!.setValue(bottomColor, forKey: "inputColor1")
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let cgImage = context.createCGImage(filter!.outputImage!, from: rect)
        let uiImage = UIImage(cgImage: cgImage!)
        
        let imageData = UIImageJPEGRepresentation(uiImage, 1.0)!
        
        return imageData
    }
}





















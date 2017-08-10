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

class UnitConverterPace: UnitConverter {
    private let coefficient: Double
    
    init(coefficient: Double) {
        self.coefficient = coefficient
    }
    
    override func baseUnitValue(fromValue value: Double) -> Double {
        return reciprocal(value * coefficient)
    }
    
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        return reciprocal(baseUnitValue * coefficient)
    }
    
    private func reciprocal(_ value: Double) -> Double {
        guard value != 0 else { return 0 }
        return 1.0 / value
    }
}

extension UnitSpeed {
    class var secondsPerMeter: UnitSpeed {
        return UnitSpeed(symbol: "sec/m", converter: UnitConverterPace(coefficient: 1))
    }
    
    class var minutesPerKilometer: UnitSpeed {
        return UnitSpeed(symbol: "min/km", converter: UnitConverterPace(coefficient: 60.0 / 1000.0))
    }
    
    class var minutesPerMile: UnitSpeed {
        return UnitSpeed(symbol: "min/mi", converter: UnitConverterPace(coefficient: 60.0 / 1609.34))
    }
}

struct FormatDisplay {
    static func distance(_ distance: Double) -> String {
        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
        return FormatDisplay.distance(distanceMeasurement)
    }
    
    static func distance(_ distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        return formatter.string(from: distance)
    }
    
    static func pace(distance: Measurement<UnitLength>, seconds: Int, outputUnit: UnitSpeed) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = [.providedUnit]
        let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
        let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
        return formatter.string(from: speed.converted(to: outputUnit))
    }
}



















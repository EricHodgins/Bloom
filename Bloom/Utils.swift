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


// MARK: - Date Extension
extension Date {
    public func delta(to: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        
        let difference = Calendar.current.dateComponents(dayHourMinuteSecond, from: self, to: to)
        
        let seconds = String(format: "%02d", difference.second!)
        let minutes = String(format: "%02d", difference.minute!)
        let hours = String(format: "%02d", difference.hour!)
        
        return hours + ":" + minutes + ":" + seconds
    }
    
    public func dateString() -> String {
        let calendar = Calendar.current
        let year = String(format: "%02d", calendar.component(.year, from: self))
        let month = String(format: "%02d", calendar.component(.month, from: self))
        let day = String(format: "%02d", calendar.component(.day, from: self))
        
        return "\(year)\\\(month)\\\(day)"
    }
    
    public func dateString(withTime: Bool) -> String {
        if !withTime { return self.dateString() }
        
        let calendar = Calendar.current
        let hour = String(format: "%02d", calendar.component(.hour, from: self))
        let minutes = String(format: "%02d", calendar.component(.minute, from: self))
        let seconds = String(format: "%02d", calendar.component(.second, from: self))
        
        let yearMonthDay = self.dateString()
        let hourMinSec = " \(hour):\(minutes):\(seconds)"
        let dateTime = yearMonthDay + hourMinSec
        return dateTime
    }
}

extension NSDate {
    public func delta(to: NSDate) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        
        let difference = Calendar.current.dateComponents(dayHourMinuteSecond, from: self as Date, to: to as Date)
        
        let seconds = String(format: "%02d", difference.second!)
        let minutes = String(format: "%02d", difference.minute!)
        let hours = String(format: "%02d", difference.hour!)
        
        return hours + ":" + minutes + ":" + seconds
    }
}

// MARK: - UIColor App Extension

extension UIColor {
    static let cancelStart = #colorLiteral(red: 1, green: 0.3333333333, blue: 0.01176470588, alpha: 1)
    static let cancelEnd = #colorLiteral(red: 1, green: 0.4392156863, blue: 0.7333333333, alpha: 1)
    
    static let doneStart = #colorLiteral(red: 0.02352941176, green: 0.5215686275, blue: 1, alpha: 1)
    static let doneEnd = #colorLiteral(red: 0.3921568627, green: 0.8392156863, blue: 1, alpha: 1)
    
    static let nextStart = #colorLiteral(red: 0.02352941176, green: 0.4392156863, blue: 0.7333333333, alpha: 1)
    static let nextEnd = #colorLiteral(red: 0.4078431373, green: 0.8509803922, blue: 0.9960784314, alpha: 1)
    
    static let addStart = #colorLiteral(red: 0.2431372549, green: 0.6235294118, blue: 0.5764705882, alpha: 1)
    static let addEnd = #colorLiteral(red: 0.4078431373, green: 0.8509803922, blue: 0.9960784314, alpha: 1)
    
    static let findStart = #colorLiteral(red: 1, green: 0.1725490196, blue: 0.01568627451, alpha: 1)
    static let findEnd = #colorLiteral(red: 1, green: 0.4862745098, blue: 0, alpha: 1)
    
    static let createStart = #colorLiteral(red: 0.6588235294, green: 0, blue: 1, alpha: 1)
    static let createEnd = #colorLiteral(red: 0.5803921569, green: 0.6901960784, blue: 1, alpha: 1)
}

// Units

struct Metric {
    static func weightMetricString() -> String {
        let weightMetric: String
        let userDefaults = UserDefaults.standard
        if let weightUnit = userDefaults.value(forKey: "WeightUnit") as? String,
            weightUnit == "lbs" {
            weightMetric = weightUnit
        } else {
            weightMetric = "kg"
        }
        return weightMetric
    }
    
    static func distanceMetricString() -> String {
        let distanceMetric: String
        let userDefaults = UserDefaults.standard
        if let distanceUnit = userDefaults.value(forKey: "DistanceUnit") as? String,
            distanceUnit == "mi" {
            distanceMetric = "mi"
        } else {
            distanceMetric = "km"
        }
        return distanceMetric
    }
}











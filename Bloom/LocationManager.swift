//
//  LocationManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-09.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import CoreLocation

class LocationManager: CLLocationManager {
    var isUpdatingLocation: Bool = false
    
    static let shared = LocationManager()
    private override init() {
        super.init()
    }
    
    override func startUpdatingLocation() {
        super.startUpdatingLocation()
        isUpdatingLocation = true
    }
    
    override func stopUpdatingLocation() {
        super.stopUpdatingLocation()
        isUpdatingLocation = false
    }
}

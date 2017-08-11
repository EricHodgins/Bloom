//
//  StateAnnotation.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-10.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import MapKit

class StateAnnotation: NSObject, MKAnnotation {
    var title: String?
    var identifier: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}

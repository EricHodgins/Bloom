//
//  LiveMapViewController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-07.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LiveMapViewController: UIViewController {

    @IBOutlet weak var mapDetailsContainerView: UIView!
    
    @IBOutlet weak var mapSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager = LocationManager.shared
    fileprivate var locationList: [CLLocation] = []
    fileprivate var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    @IBAction func switchPressed(_ sender: Any) {
        if mapSwitch.isOn {
            locationManager.requestWhenInUseAuthorization()
            mapDetailsContainerView.isHidden = false
            mapSwitch.isHidden = true
            switchLabel.isHidden = true
            startMapTracking()
        }
    }
    
    private func startMapTracking() {
        mapView.removeOverlays(mapView.overlays)
        locationList.removeAll()
        distance = Measurement(value: 0, unit: UnitLength.meters)
        startLocationUpdates()
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }

}


extension LiveMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
        }
    }
}

extension LiveMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}

















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
    
    @IBOutlet weak var mapTypeButton: UIButton!
    @IBOutlet weak var mapSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    fileprivate let locationManager = LocationManager.shared
    fileprivate var locationList: [CLLocation] = []
    fileprivate var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var timer: Timer?
    private var seconds = 0
    
    fileprivate var startLocation: CLLocationCoordinate2D?
    fileprivate var finishLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    @IBAction func switchPressed(_ sender: Any) {
        if mapSwitch.isOn {
            locationManager.requestAlwaysAuthorization()
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
        seconds = 0
        startLocationUpdates()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.eachSecond()
        })
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    private func eachSecond() {
        seconds += 1
        DispatchQueue.main.async {
            self.updateDisplay()
        }
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile)
        distanceLabel.text = formattedDistance
        paceLabel.text = formattedPace
    }

    @IBAction func mapTypeButtonPressed(_ sender: Any) {
        if mapView.mapType == .satellite {
            mapView.mapType = .standard
            mapTypeButton.setTitle("Satellite", for: .normal)
        } else {
            mapView.mapType = .satellite
            mapTypeButton.setTitle("Standard", for: .normal)
        }
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
            addStartLocation()
        }
    }
    
    private func addStartLocation() {
        guard startLocation == nil else { return }
        
        let first = locationList.first
        let annotation = MKPointAnnotation()
        annotation.coordinate = first!.coordinate
        mapView.addAnnotation(annotation)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        annotationView.image = UIImage(named: "StartPin")
        
        return annotationView
    }
}

















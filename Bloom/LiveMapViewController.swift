//
//  LiveMapViewController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-07.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import MapKit

protocol MapRouteDelegate: class {
    func saveRoute()
}

class LiveMapViewController: UIViewController {
    
    var workoutSession: WorkoutSessionManager!
    var managedContext: NSManagedObjectContext!

    @IBOutlet weak var mapDetailsContainerView: UIView!
    
    @IBOutlet weak var mapTypeButton: UIButton!
    @IBOutlet weak var mapSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    var paceUnit: UnitSpeed!
    
    fileprivate let locationManager: LocationManager = LocationManager.shared
    fileprivate var locationList: [CLLocation] = []
    fileprivate var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var timer: Timer?
    private var seconds = 0
    
    fileprivate var startLocation: CLLocationCoordinate2D?
    fileprivate var finishLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Metric.paceString() == "min/mi" {
            paceUnit = UnitSpeed.minutesPerMile
        } else {
            paceUnit = UnitSpeed.minutesPerKilometer
        }
        
        workoutSession.mapRouteDelegate = self
        mapView.delegate = self
    }

    @IBAction func switchPressed(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            if mapSwitch.isOn {
                locationManager.requestWhenInUseAuthorization()
                mapDetailsContainerView.isHidden = false
                mapSwitch.isHidden = true
                switchLabel.isHidden = true
                startMapTracking()
            }
        } else {
            
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
        locationManager.distanceFilter = 3
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: paceUnit)
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
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        presentAlertViewController()
    }
    
    fileprivate func saveMapRoute() {
        if locationManager.isUpdatingLocation {
            locationManager.stopUpdatingLocation()
        }
        
        for location in locationList {
            let locationObject = Location(context: managedContext)
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            locationObject.timeStamp = location.timestamp
            workoutSession.workout.addToLocations(locationObject)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save locations: \(error)")
        }
    }
    
    private func presentAlertViewController() {
        let alertController = UIAlertController(title: "Route Tracking", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let saveButton = UIAlertAction(title: "Save and Stop", style: .default, handler: { (action) -> Void in
            print("Saving map route..")
            self.addFinishLocation()
            self.locationManager.stopUpdatingLocation()
            self.timer?.invalidate()
            self.saveMapRoute()
        })
        
        let stateButton: UIAlertAction
        if locationManager.isUpdatingLocation {
            stateButton = UIAlertAction(title: "Pause", style: .destructive, handler: { (action) -> Void in
                print("Pausing location updates")
                self.locationManager.stopUpdatingLocation()
            })
        } else {
            stateButton = UIAlertAction(title: "Resume", style: .destructive, handler: { (action) -> Void in
                print("Resuming location updates")
                self.locationManager.startUpdatingLocation()
            })
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alertController.addAction(saveButton)
        alertController.addAction(stateButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
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
    
    fileprivate func addStartLocation() {
        guard startLocation == nil else { return }
        
        let first = locationList.first
        let annotation = StateAnnotation(title: "Start", coordinate: first!.coordinate)
        annotation.identifier = "Start"
        mapView.addAnnotation(annotation)
    }
    
    fileprivate func addFinishLocation() {
        guard finishLocation == nil else { return }
        
        let last = locationList.last
        let annotation = StateAnnotation(title: "Finish", coordinate: last!.coordinate)
        annotation.identifier = "Finish"
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
        let annotationView = MKAnnotationView()
        if let annotation = annotation as? StateAnnotation {
            if annotation.identifier == "Start" {
                annotationView.image = UIImage(named: "StartPin")
            }
            
            if annotation.identifier == "Finish" {
                annotationView.image = UIImage(named: "FinishPin")
            }
        }
        
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = nil
        
        return annotationView
    }
}



extension LiveMapViewController: MapRouteDelegate {
    func saveRoute() {
        saveMapRoute()
    }
}










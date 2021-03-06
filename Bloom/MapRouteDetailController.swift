//
//  MapRouteDetailController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-13.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class MapRouteDetailController: UIViewController {
    
    var workout: Workout!
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeButton: UIButton!
    
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    var locations: [Location] = []
    var speeds: [Double] = []
    var totalDistance = Measurement(value: 0, unit: UnitLength.meters)
    var segments: [MultiColorPolyLine] = []
    var segmentCoordinates: [(CLLocation, CLLocation)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let workout = workout,
            let _ = workout.startTime,
            let _ = workout.endTime else {
                //Present no workout data
                present(AlertManager.alert(title: "No Workout Data.", message: "You're last workout map data will appear here.", style: .alert), animated: true)
                return
        }
        
        let summarizer = WorkoutSummary(workout: workout)
        summarizer.delegate = self
        mapView.delegate = self
        // 1. This must be first
        fetchLocationObjects()
        
        // 2. Set Map View from location objects if any
        configureMapRegion()
        
        // 3. Add Overlays for speed
        addOverlays()
    }
    
    private func fetchLocationObjects() {
        locations = workout.locations?.array as! [Location]
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard locations.count > 0 else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func configureMapRegion() {
        let calculatedRegion = mapRegion()
        guard let region = calculatedRegion else {
            //TODO: - Setup alert controller for user
            return
        }
        mapView.setRegion(region, animated: true)
    }
    
    private func calculateSpeeds() {
        for (first, second) in zip(locations, locations.dropFirst()) {
            let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
            let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
            
            // V = d/t
            let distance = end.distance(from: start)
            totalDistance = totalDistance + Measurement(value: distance, unit: UnitLength.meters)
            let time = second.timeStamp!.timeIntervalSince(first.timeStamp! as Date)
            let speed = time > 0 ? distance / time : 0 // metres / second
            
            if isRationalSpeed(speed) {
                speeds.append(speed)
                segmentCoordinates.append((start, end))
            }
        }
    }
    
    // The fastest speed a human has run is around 40-45 km/hr (11 m/s)
    private func isRationalSpeed(_ speed: Double) -> Bool {
        if speed > 11 {
            return false
        }
        return true
    }
    
    private func calculateSegmentColors() {
        guard speeds.count > 0 else { return }
        let maxSpeed = speeds.max()!
        let minSpeed = speeds.min()!
        let avgSpeed: Double = speeds.reduce(0, +) / Double(speeds.count)
        
        configureLabels(max: maxSpeed, min: minSpeed, avg: avgSpeed)
        
        for ((start, end), speed) in zip(segmentCoordinates, speeds) {
            let coords = [start.coordinate, end.coordinate]
            let segment = MultiColorPolyLine(coordinates: coords, count: 2)
            segment.color = MultiColorPolyLine.segmentColor(max: maxSpeed, min: minSpeed, avg: avgSpeed, speed: speed)
            segments.append(segment)
        }
    }
    
    private func addOverlays() {
        calculateSpeeds()
        calculateSegmentColors()
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            guard self.segments.count != 0 else {
                timer.invalidate()
                return
            }
            let segment = self.segments.removeFirst()
            self.mapView.add(segment)
        }
    }
    
    @IBAction func mapTypeButtonPressed(_ sender: Any) {
        if mapView.mapType == .standard {
            mapView.mapType = .satellite
            mapTypeButton.setTitle("Standard", for: .normal)
        } else {
            mapView.mapType = .standard
            mapTypeButton.setTitle("Satellite", for: .normal)
        }
    }
    
    private func configureLabels(max: Double, min: Double, avg: Double) {
        let maxSpeed = Measurement(value: max, unit: UnitSpeed.metersPerSecond)
        let avgSpeed = Measurement(value: avg, unit: UnitSpeed.metersPerSecond)
        
        var maxMetric: Measurement<UnitSpeed> = maxSpeed.converted(to: UnitSpeed.kilometersPerHour)
        var avgMetric: Measurement<UnitSpeed> = avgSpeed.converted(to: UnitSpeed.kilometersPerHour)
        
        if let speedMetric = userDefaults.value(forKey: "SpeedUnit") as? String {
            if speedMetric == "km/hr" {
                maxMetric = maxSpeed.converted(to: UnitSpeed.kilometersPerHour)
                avgMetric = avgSpeed.converted(to: UnitSpeed.kilometersPerHour)
            }
            
            if speedMetric == "mi/hr" {
                maxMetric = maxSpeed.converted(to: UnitSpeed.milesPerHour)
                avgMetric = avgSpeed.converted(to: UnitSpeed.milesPerHour)
            }
            
            let fmtMax = String(format: "%.2f", maxMetric.value)
            let fmtMin = String(format: "%.2f", avgMetric.value)
            maxSpeedLabel.text = "Max Speed: \(fmtMax) \(maxMetric.unit.symbol)"
            averageSpeedLabel.text = "Avg Speed: \(fmtMin) \(avgMetric.unit.symbol)"
        } else {
            let formatter = MeasurementFormatter()
            let maxSpeedText = formatter.string(from: maxSpeed)
            let avgSpeedText = formatter.string(from: avgSpeed)
            maxSpeedLabel.text = "Max Speed: \(maxSpeedText)"
            averageSpeedLabel.text = "Avg Speed: \(avgSpeedText)"
        }
    }
    
}

class AnimationRenderer: MKOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        
    }
}


extension MapRouteDetailController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MultiColorPolyLine else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 3
        
        return renderer
    }
}


extension MapRouteDetailController: WorkoutSummarizer {
    func maxBPM(bpm: Double?) {
        
    }
    
    func minBPM(bpm: Double?) {
        
    }
    
    func avgBPM(bpm: Double?) {
        
    }
    
    func totalDistance(inMetres metres: Measurement<UnitLength>) {
        var metric = metres.converted(to: UnitLength.kilometers)
        
        if let distanceUnit = userDefaults.value(forKey: "DistanceUnit") as? String {
            if distanceUnit == "km" {
                
            }
            
            if distanceUnit == "mi" {
                metric = metres.converted(to: UnitLength.miles)
            }
            
            let formattedValue = String(format: "%.2f", metric.value)
            distanceLabel.text = "Distance: \(formattedValue) \(metric.unit.symbol)"
        } else {
            let formatter = MeasurementFormatter()
            let text = formatter.string(from: metric)
            distanceLabel.text = "Distance: \(text)"
        }
    }
}













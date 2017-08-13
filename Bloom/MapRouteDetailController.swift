//
//  MapRouteDetailController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-13.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class MapRouteDetailController: UIViewController {
    
    var workout: Workout!
    var managedContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocationObjects()
    }
    
    private func fetchLocationObjects() {
        guard let start = workout.startTime as Date?,
              let finish = workout.endTime as Date? else { return }
        let locations = BloomFilter.fetchLocations(startDate: start, finishDate: finish, inManagedContext: managedContext)
        
        for location in locations {
            print("\(location.latitude) - \(location.longitude): \(location.timeStamp ?? NSDate())")
        }
    }
}

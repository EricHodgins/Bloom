//
//  HeartBeatGraphController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-02.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import HealthKit

class HeartBeatGraphController: UIViewController {

    @IBOutlet weak var graphView: GraphView!
    
    var workout: Workout!
    let hrUnit = HKUnit(from: "count/min")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryHeartRateDataFromHealthStore()
    }
    
    func queryHeartRateDataFromHealthStore() {
        let healthService = HealthDataService()
        healthService.queryHeartRateData(withStartDate: workout.startTime! as Date, toEndDate: workout.endTime! as Date) { results in
            self.printQueriedResults(results: results)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        graphView.setNeedsDisplay()
    }
    
    //MARK: - Test Code, Remove later
    func printQueriedResults(results: [HKSample]?) {
        guard let results = results as? [HKQuantitySample] else { return }
        var dataSet: [Double] = []
        for sample in results {
            let hrValue = sample.quantity.doubleValue(for: hrUnit)
            print("Queried result: \(hrValue) - started: \(sample.startDate)")
            dataSet.append(hrValue)
        }
        graphView.dataSet = dataSet
    }
}

//
//  FilterGraphController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-03.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate: class {
    func filter(withPredicates predicates: [NSPredicate], sortDescriptor: [NSSortDescriptor])
}

class FilterGraphController: UITableViewController {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var workoutName: String!
    var excerciseName: String!
    let bloomFilter: BloomFilter = BloomFilter()
    weak var delegate: FilterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let threeMonthsAgoFromToday = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        startDatePicker.date = threeMonthsAgoFromToday
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPressed(_ sender: Any) {
        let workoutNamePredicate = bloomFilter.workoutForNamePredicate(workoutName)
        let excerciseNamePredicate = bloomFilter.excerciseNamePredicate(excerciseName)
        let datePredicate = bloomFilter.datePredicate(startDatePicker.date, endDatePicker.date)
        let workoutDateSortDescriptor = bloomFilter.workoutDateSortDescriptor
        delegate?.filter(withPredicates: [workoutNamePredicate, excerciseNamePredicate, datePredicate], sortDescriptor: [workoutDateSortDescriptor])
        dismiss(animated: true, completion: nil)
    }
    
}

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
    weak var delegate: FilterViewControllerDelegate?
    
    lazy var datePredicate: NSPredicate = {
        let predicate = NSPredicate(format: "%K >= %@ && %K <= %@", #keyPath(Excercise.workout.startTime), self.startDatePicker.date as NSDate, #keyPath(Excercise.workout.startTime), self.endDatePicker.date as NSDate)
        
        return predicate
    }()
    
    lazy var workoutForNamePredicate: NSPredicate = {
        return NSPredicate(format: "%K == %@", #keyPath(Excercise.workout.name), self.workoutName)
    }()
    
    lazy var workoutDateSortDescriptor: NSSortDescriptor = {
        return NSSortDescriptor(key: #keyPath(Excercise.workout.startTime), ascending: true)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let threeMonthsAgoFromToday = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        startDatePicker.date = threeMonthsAgoFromToday
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func showPressed(_ sender: Any) {
        delegate?.filter(withPredicates: [workoutForNamePredicate, datePredicate], sortDescriptor: [workoutDateSortDescriptor])
        dismiss(animated: true, completion: nil)
    }
}

//
//  LiveExcerciseListController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-07.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class LiveExcerciseListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var excercises = [Excercise]()
    var workoutsession: WorkoutSessionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    deinit {
        print("LIVE LIST DEINIT..")
    }
}

extension LiveExcerciseListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return excercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let excercise = excercises[indexPath.row]
        
        cell.textLabel?.text = "\(excercise.name!)"
        cell.detailTextLabel?.text = "S:\(excercise.sets), R:\(excercise.reps), W:\(excercise.weight), D:\(excercise.distance)"
        
        return cell
    }
}

extension LiveExcerciseListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(displayP3Red: 252/255, green: 123/255, blue: 151/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    }
}

extension LiveExcerciseListController {
    func updateExcerciseList(sets: String, reps: String, weight: String, distance: String, position: Int16) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}




















//
//  ExcercisesController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-03.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class ExcercisesController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var managedContext: NSManagedObjectContext!
    var workoutName: String!
    var excercises: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        tableView.dataSource = self
        tableView.delegate = self
        fetchExcercises()
    }
    
    func fetchExcercises() {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "ExcerciseTemplate")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ExcerciseTemplate.workout.name), workoutName)
        fetchRequest.predicate = predicate
        fetchRequest.returnsDistinctResults = true
        
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["name"]
        
        do {
           excercises = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Excercise Template Fetch error: \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGraph" {
            let graphViewController = segue.destination as! GraphViewController
            graphViewController.managedContext = managedContext
            graphViewController.workoutName = workoutName
            
            let cellIndex = tableView.indexPathForSelectedRow!
            let name = excercises[cellIndex.row]["name"] as! String
            graphViewController.excerciseName = name
        }
    }

}

extension ExcercisesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return excercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = excercises[indexPath.row]["name"] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
        
        return cell
    }
}

extension ExcercisesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(colorLiteralRed: 100/255, green: 212/255, blue: 255/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    }
}


































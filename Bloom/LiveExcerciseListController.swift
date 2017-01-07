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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
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
        
        return cell
    }
}

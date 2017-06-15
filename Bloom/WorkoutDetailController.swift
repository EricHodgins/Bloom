//
//  WorkoutDetailController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class WorkoutDetailController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension WorkoutDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutInfoCell", for: indexPath) as! WorkoutTableCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExcerciseCell", for: indexPath) as! ExcerciseTableCell
        
        return cell
    }
    
}

extension WorkoutDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.bounds.height * 0.25
        }
        return view.bounds.height * 0.333
    }
}

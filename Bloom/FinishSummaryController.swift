//
//  FinishSummaryController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-08-04.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import SpriteKit

class FinishSummaryController: UIViewController {
    
    lazy var scene: FinishScene! = {
        return FinishScene(size: self.view.frame.size)
    }()

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var highBPMLabel: UILabel!
    @IBOutlet weak var lowBPMLabel: UILabel!
    @IBOutlet weak var avgBPMLabel: UILabel!
    
    var workout: Workout!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.backgroundColor = UIColor.clear
        skView.presentScene(scene)
        
        tableView.dataSource = self
        tableView.tableHeaderView = nil
    }
    
    
    @IBAction func dismissPressed(_ sender: Any) {
        scene.removeFlareAction()
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
}

extension FinishSummaryController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Test"
        
        
        return cell
    }
    
}


























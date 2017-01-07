//
//  LiveWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class LiveWorkoutController: UIViewController {

    @IBOutlet weak var workoutDurationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heartBeatView: HeartBeatView!
    @IBOutlet weak var currentExcerciseLabel: UILabel!

    var startTime: TimeInterval!
    var managedContext: NSManagedObjectContext!
    var workout: Workout!
    
    lazy var excercises: [Excercise] = {
        var excercises = [Excercise]()
        for e in self.workout.excercises! {
            excercises.append(e as! Excercise)
        }
    
        return excercises
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        startTime = Date.timeIntervalSinceReferenceDate
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(LiveWorkoutController.startTimer), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LiveWorkoutController.startHeartLineAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startHeartLineAnimation()
    }
    
    @IBAction func nextExcerciseButtonPressed(_ sender: Any) {
    }
    
    @IBAction func workoutFinishedButtonPressed(_ sender: Any) {
    }
    
    
}

extension LiveWorkoutController {
    func startTimer() {
        let finish = Date.timeIntervalSinceReferenceDate
        var diff = finish - startTime
        
        let hours = Int16(diff / 3600)
        
        diff -= TimeInterval(hours * 3600)
        
        let minutes = Int16(diff / 60)
        
        diff -= TimeInterval(minutes * 60)
        
        let seconds = Int8(diff)
        
        let hoursFormatted = String(format: "%02d", hours)
        let minutesFormatted = String(format: "%02d", minutes)
        let secondsFormatted = String(format: "%02d", seconds)
        
        DispatchQueue.main.async {
            self.workoutDurationLabel.text = "\(hoursFormatted):\(minutesFormatted):\(secondsFormatted)"
        }
    }
    
    func startHeartLineAnimation() {
        heartBeatView.startAnimatingHeartLine()
    }
}

extension LiveWorkoutController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.excercises!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let excercise = excercises[indexPath.row]
        cell.textLabel?.text = "\(excercise.name!)"
        
        return cell
    }
}








































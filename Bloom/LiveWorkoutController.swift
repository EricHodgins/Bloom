//
//  LiveWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class LiveWorkoutController: UIViewController {

    @IBOutlet weak var workoutDurationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heartBeatView: UIView!
    @IBOutlet weak var currentExcerciseLabel: UILabel!

    var startTime: TimeInterval!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startTime = Date.timeIntervalSinceReferenceDate
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(LiveWorkoutController.startTimer), userInfo: nil, repeats: true)
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
        
        let minutes = Int8(diff / 60)
        
        diff -= TimeInterval(minutes * 60)
        
        let seconds = Int8(diff)
        
        let hoursFormatted = String(format: "%02d", hours)
        let minutesFormatted = String(format: "%02d", minutes)
        let secondsFormatted = String(format: "%02d", seconds)
        
        DispatchQueue.main.async {
            self.workoutDurationLabel.text = "\(hoursFormatted):\(minutesFormatted):\(secondsFormatted)"
        }
    }
}










































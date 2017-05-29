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
    @IBOutlet weak var heartBeatView: HeartBeatView!
    @IBOutlet weak var currentExcerciseLabel: UILabel!

    var startTime: TimeInterval!
    var managedContext: NSManagedObjectContext!
    var workout: Workout!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var pages = [UIViewController]()
    
    lazy var excercises: [Excercise] = {
        var excercises = [Excercise]()
        excercises = self.workout.excercises!.sorted { (e1, e2) -> Bool in
            return (e1 as! Excercise).orderNumber < (e2 as! Excercise).orderNumber
        } as! [Excercise]

        return excercises
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workout.startTime = NSDate()
        scrollView.isScrollEnabled = false
        
        // Start Timer
        startTime = Date.timeIntervalSinceReferenceDate
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(LiveWorkoutController.startTimer), userInfo: nil, repeats: true)
        
        // Need to restart the heart beat animation when app leaves foreground and comes back.
        NotificationCenter.default.addObserver(self, selector: #selector(LiveWorkoutController.startHeartLineAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        // Setup Pages for scroll view
        let page1 = createRecordLiveExcerciseController()
        let page2 = createLiveExcerciseListController()
        let page3 = createLiveMapController()
        let page4 = createFinishLiveWorkoutController()
        
        pages = [page1, page2, page3, page4]
        
        let views: [String: UIView] = ["view": scrollView, "page1": page1.view, "page2": page2.view, "page3": page3.view, "page4": page4.view]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat:"V:|[page1(==view)]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraints)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[page1(==view)][page2(==view)][page3(==view)][page4(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startHeartLineAnimation()
    }
    
    @IBAction func segmentControllTapped(_ sender: UISegmentedControl) {
        
        let width = scrollView.bounds.width
        
        UIView.animate(withDuration: 0.33) {
            self.scrollView.contentOffset.x = width * CGFloat(sender.selectedSegmentIndex)
        }
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
        
        let seconds = Int16(diff)
        
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

extension LiveWorkoutController {
    
    fileprivate func createRecordLiveExcerciseController() -> RecordLiveExcerciseController {
        let rlec = storyboard!.instantiateViewController(withIdentifier: "Record") as! RecordLiveExcerciseController
        rlec.view.translatesAutoresizingMaskIntoConstraints = false
        
        rlec.excerciseLabel = currentExcerciseLabel
        rlec.managedContext = managedContext
        rlec.excercises = excercises
        
        scrollView.addSubview(rlec.view)
        
        addChildViewController(rlec)
        
        return rlec
    }
    
    fileprivate func createLiveExcerciseListController() -> LiveExcerciseListController {
        let lelc = storyboard!.instantiateViewController(withIdentifier: "List") as! LiveExcerciseListController
        lelc.view.translatesAutoresizingMaskIntoConstraints = false
        lelc.excercises = excercises
        
        scrollView.addSubview(lelc.view)
        
        addChildViewController(lelc)
        
        return lelc
    }
    
    fileprivate func createLiveMapController() -> LiveMapViewController {
        let lmc = storyboard!.instantiateViewController(withIdentifier: "Map") as! LiveMapViewController
        lmc.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(lmc.view)
        
        addChildViewController(lmc)
        
        return lmc
    }
    
    fileprivate func createFinishLiveWorkoutController() -> FinishLiveWorkoutController {
        let flwc = storyboard!.instantiateViewController(withIdentifier: "Finish") as! FinishLiveWorkoutController
        flwc.workout = workout
        flwc.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(flwc.view)
        
        addChildViewController(flwc)
        
        return flwc
    }
    
}







































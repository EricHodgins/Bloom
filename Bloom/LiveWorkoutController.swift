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
    
    var workoutSessionManager: WorkoutSessionManager!
    var workoutName: String!
    var startTime: TimeInterval!
    var currentWatchInterval: TimeInterval!
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var pages = [UIViewController]()
    var flwc: FinishLiveWorkoutController!
    var rlec: RecordLiveExcerciseController!

    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var heartRateStreamingButton: UIButton!
    var isStreamingHeartRate: Bool = false
    var phoneConnectivityManager: PhoneConnectivityManager?
    
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        phoneConnectivityManager = appDelegate.phoneConnectivityManager
        
        if workoutSessionManager.deviceInitiation == .phone {
            currentWatchInterval = 0.0
        } else {
            currentWatchInterval = Date.timeIntervalSinceReferenceDate - workoutSessionManager.workout.startTime!.timeIntervalSinceReferenceDate
        }
  
        scrollView.isScrollEnabled = false
        
        // Start Timer
        startTime = Date.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(LiveWorkoutController.startTimer), userInfo: nil, repeats: true)
        
        setupNotifications()
        setupViewLayout()
    }
    
    deinit {
        print("LIVE WORKOUT CONTROLLER DEINIT")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation == .portrait {
            scrollView.isHidden = false
        } else {
            scrollView.isHidden = true
        }
    }
    
    func setupViewLayout() {
        // Setup Pages for scroll view
        let page1 = createRecordLiveExcerciseController()
        let page2 = createLiveExcerciseListController()
        page1.workoutListDelegate = page2
        let page3 = createLiveMapController()
        page3.mappedDistanceDelegate = page1
        let page4 = createFinishLiveWorkoutController()
        page1.progressDelegate = page4
        //pages = [page1, page2, page3, page4]
        pages = [page4]
        
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
    
    func setupNotifications() {
        // Need to restart the heart beat animation when app leaves foreground and comes back.
        NotificationCenter.default.addObserver(self, selector: #selector(LiveWorkoutController.startHeartLineAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    // Sync Pressed on watch - triggered from PhoneConnectivity manager
    func sendStateToWatch() {
        if workoutSessionManager.deviceInitiation == .phone {
            let startDate = workoutSessionManager.workout.startTime!
            let excercises = workoutSessionManager.excercises
            let excerciseNames = excercises.map { (excercise) -> String in
                return excercise.name!
            }
            let userInfo: [String: Any] = ["StartDate" : startDate,
                                           "Name": workoutName,
                                           "Excercises": excerciseNames
            ]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLiveWorkoutStarted), object: nil, userInfo: userInfo)
            
        }
    }
    
    // MARK: - Start/Stop Streaming Heart Rate
    @IBAction func heartStreamingButtonPressed(_ sender: Any) {
        if isStreamingHeartRate == false {
            isStreamingHeartRate = true
            phoneConnectivityManager?.requestToStreamHeartRate(stream: true)
        } else {
            isStreamingHeartRate = false
            phoneConnectivityManager?.requestToStreamHeartRate(stream: false)
            heartRateLabel.text = "-- BPM"
        }
    }
    
    
}

extension LiveWorkoutController {
    @objc func startTimer() {
        let finish = Date.timeIntervalSinceReferenceDate + currentWatchInterval
        var diff = finish - startTime

        let hours = Int16(diff / 3600)

        diff -= TimeInterval(hours * 3600)

        let minutes = Int16(diff / 60)

        diff -= TimeInterval(minutes * 60)

        let seconds = Int16(diff)

        let hoursFormatted = String(format: "%02d", hours)
        let minutesFormatted = String(format: "%02d", minutes)
        let secondsFormatted = String(format: "%02d", seconds)

        DispatchQueue.main.async { [unowned self] in
            self.workoutDurationLabel.text = "\(hoursFormatted):\(minutesFormatted):\(secondsFormatted)"
        }
        
        if workoutSessionManager.state == .finished {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func startHeartLineAnimation() {
        heartBeatView.startAnimatingHeartLine()
    }
}

extension LiveWorkoutController {
    
    fileprivate func createRecordLiveExcerciseController() -> RecordLiveExcerciseController {
        rlec = storyboard!.instantiateViewController(withIdentifier: "Record") as! RecordLiveExcerciseController
        rlec.view.translatesAutoresizingMaskIntoConstraints = false
        
        rlec.workoutSession = workoutSessionManager
        rlec.workoutName = workoutName
        rlec.excerciseLabel = currentExcerciseLabel
        rlec.managedContext = managedContext
        
        scrollView.addSubview(rlec.view)
        
        addChildViewController(rlec)
        
        return rlec
    }
    
    fileprivate func createLiveExcerciseListController() -> LiveExcerciseListController {
        let lelc = storyboard!.instantiateViewController(withIdentifier: "List") as! LiveExcerciseListController
        lelc.view.translatesAutoresizingMaskIntoConstraints = false
        lelc.workoutsession = workoutSessionManager
        lelc.excercises = workoutSessionManager.excercises
        
        scrollView.addSubview(lelc.view)
        
        addChildViewController(lelc)
        
        return lelc
    }
    
    fileprivate func createLiveMapController() -> LiveMapViewController {
        let lmc = storyboard!.instantiateViewController(withIdentifier: "Map") as! LiveMapViewController
        lmc.workoutSession = workoutSessionManager
        lmc.managedContext = managedContext
        lmc.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(lmc.view)
        
        addChildViewController(lmc)
        
        return lmc
    }
    
    fileprivate func createFinishLiveWorkoutController() -> FinishLiveWorkoutController {
        let workout = workoutSessionManager.workout!
        
        flwc = storyboard!.instantiateViewController(withIdentifier: "Finish") as! FinishLiveWorkoutController
        flwc.workout = workout
        flwc.workoutSession = workoutSessionManager
        flwc.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(flwc.view)
        
        addChildViewController(flwc)
        
        return flwc
    }
}

extension LiveWorkoutController {
    func workoutFinishedOnWatch() {
        guard let workout = workoutSessionManager.workout else { return }
        
        workout.endTime = Date()
        do {
            try workout.managedObjectContext?.save()
        } catch let error as NSError {
            print("Save Error at Finish Workout Button: \(error), \(error.userInfo)")
        }
        
        flwc.segueToMainMenu()
    }
}

//MARK: - Streaming Heart Rate
extension LiveWorkoutController {
    func updateHeartRate(value: String) {
        DispatchQueue.main.async { [unowned self] in
            self.heartRateLabel.text = value
        }
    }
}




































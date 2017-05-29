//
//  FinishLiveWorkoutController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-07.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class FinishLiveWorkoutController: UIViewController {

    //var sunsetBackground: SunsetBackground!
    var workout: Workout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sunsetBackground = SunsetBackground(frame: view.bounds, device: nil, withView: view)
        //view.insertSubview(sunsetBackground, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func finishWorkoutButtonPressed(_ sender: Any) {
        workout.endTime = NSDate()
        do {
            try workout.managedObjectContext?.save()
        } catch let error as NSError {
            print("Save Error at Finish Workout Button: \(error), \(error.userInfo)")
        }
        
        performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
}

























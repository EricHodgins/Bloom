//
//  RecordLiveExcerciseController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-07.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class RecordLiveExcerciseController: UIViewController {
    
    var excercises = [Excercise]()
    weak var excerciseLabel: UILabel!
    var currentExcerciseIndex: Int = -1
    
    var recordLiveStatView: RecordLiveStatView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextExcerciseTapped(excerciseLabel)
    }
    
    @IBAction func nextExcerciseTapped(_ sender: Any) {
        DispatchQueue.main.async {
            let exc = self.getNextExcercise()
            self.excerciseLabel.text = exc.name!
        }
    }
    
    func getNextExcercise() -> Excercise {
        currentExcerciseIndex += 1
        if excercises.count > currentExcerciseIndex {
            return excercises[currentExcerciseIndex]
        }
        
        currentExcerciseIndex = 0
        return excercises[0]
    }
    
    func getCurrentExcercise() -> Excercise {
       return excercises[currentExcerciseIndex]
    }
    
    func excerciseListLoopedOver() {
        
    }
    
    
    @IBAction func repsButtonPushed(_ sender: Any) {
        showRecordRepsView()
    }
    
    @IBAction func weightsButtonPushed(_ sender: Any) {
    }
    
    @IBAction func distanceButtonPushed(_ sender: Any) {
    }
    
    @IBAction func timeButtonPushed(_ sender: Any) {
    }
    
    func showRecordRepsView() {
        recordLiveStatView = RecordLiveStatView(inView: view)
        recordLiveStatView.title.text = "Reps"
        recordLiveStatView.textField.placeholder = "0"
        view.addSubview(recordLiveStatView)
    }
}






























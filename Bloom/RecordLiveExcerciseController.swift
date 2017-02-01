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
    var blurEffectView: UIVisualEffectView!

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
        addBlurEffect()
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
        recordLiveStatView.plusButton.addTarget(self, action: #selector(RecordLiveExcerciseController.plusButtonPushed(sender:)), for: .touchUpInside)
        recordLiveStatView.saveButton.addTarget(recordLiveStatView, action: #selector(RecordLiveStatView.savePressed), for: .touchUpInside)
        recordLiveStatView.cancelButton.addTarget(recordLiveStatView, action: #selector(RecordLiveStatView.cancelPressed), for: .touchUpInside)
        
        recordLiveStatView.completionHandler = { (reps) in
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffectView.alpha = 0
            }, completion: {_ in
                self.blurEffectView.removeFromSuperview()
            })
            
        }
        
        view.addSubview(recordLiveStatView)
    }
    
    func plusButtonPushed(sender: UIButton) {
        
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}






























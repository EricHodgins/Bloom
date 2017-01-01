//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

//PlaygroundPage.current.needsIndefiniteExecution = true


func delay(seconds: Int, completionHandler: @escaping (() -> Void)) {
    let delayInMilliSeconds = DispatchTime.now() + DispatchTimeInterval.milliseconds(seconds)
    DispatchQueue.main.asyncAfter(deadline: delayInMilliSeconds, execute: completionHandler)
}

protocol CountDown: class {
    func countDownComplete()
}

class StartWorkout: CountDown {
    
    func countDownComplete() {
        print("Count down is complete.")
    }
    
    deinit {
        print("Start Workout deinit.")
    }
}

class AssembleView  {
    
    weak var delegate: CountDown!
    
    func beginCountDown() {
        delay(seconds: 3000) { [unowned self] in
            self.delegate.countDownComplete()
        }
    }
    
    deinit {
        print("AssembleView deinit.")
    }
}

var workout: StartWorkout? = StartWorkout()
var assembleView: AssembleView? = AssembleView()
assembleView?.delegate = workout
assembleView?.beginCountDown()


workout = nil
assembleView = nil





























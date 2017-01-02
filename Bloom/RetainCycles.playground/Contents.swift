//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

//PlaygroundPage.current.needsIndefiniteExecution = true


func delay(seconds: Int, completionHandler: @escaping (() -> Void)) {
    let delayInMilliSeconds = DispatchTime.now() + DispatchTimeInterval.seconds(seconds)
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

//var workout: StartWorkout? = StartWorkout()
//var assembleView: AssembleView? = AssembleView()
//assembleView?.delegate = workout
//assembleView?.beginCountDown()
//
//
//workout = nil
//assembleView = nil

class StopWatch {
    var startTime = TimeInterval()
    
    init() {
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StopWatch.updateTime), userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
    }
    
    @objc func updateTime() {
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
        
        print("\(hoursFormatted):\(minutesFormatted):\(secondsFormatted)")//:\(minutes):\(seconds)")
    }
}


var start: TimeInterval = Date.timeIntervalSinceReferenceDate

delay(seconds: 3) {
    let finish = Date.timeIntervalSinceReferenceDate + 3660
    var diff = finish - start
    print("\(start) - \(finish))")
    
    let hours = Int16(diff / 3600)
    
    diff -= TimeInterval(hours * 3600)
    
    let minutes = Int8(diff / 60)
    
    diff -= TimeInterval(minutes * 60)
    
    let seconds = Int8(diff)
    
    print("\(hours):\(minutes):\(seconds)")//:\(minutes):\(seconds)")
}


let stopWatch = StopWatch()




















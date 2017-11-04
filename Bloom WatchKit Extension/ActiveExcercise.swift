//
//  ActiveExcercise.swift
//  Bloom WatchKit Extension
//
//  Created by Eric Hodgins on 2017-11-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

struct ActiveExcercise {
    var name: String
    var sets: String
    var reps: String
    var weight: String
    var distance: String
    var workoutExcerciseIndex: Int
    
    init(name: String, sets: String, reps: String, weight: String, distance: String, index: Int) {
        self.name = name
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.distance = distance
        self.workoutExcerciseIndex = index
    }
}

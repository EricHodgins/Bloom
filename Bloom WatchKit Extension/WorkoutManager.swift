//
//  WorkoutManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-01.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

class WorkoutManager {
    static let shared = WorkoutManager()
    private init() {}
    
    var workouts: [String] = []
}

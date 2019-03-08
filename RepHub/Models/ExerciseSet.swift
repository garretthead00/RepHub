//
//  ExerciseSet.swift
//  RepHub
//
//  Created by Garrett Head on 3/7/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class ExerciseSet {
    var set : Int?
    var weight : Double?
    var reps : Int?
    var score : Double?
    
    init(set: Int, weight: Double, reps: Int, score: Double) {
        self.set = set
        self.weight = weight
        self.reps = reps
        self.score = score
    }
}

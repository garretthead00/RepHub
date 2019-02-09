//
//  ExerciseTarget.swift
//  RepHub
//
//  Created by Garrett Head on 2/9/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

struct ExerciseTarget {
    var id : String?
    var set : Int?
    var reps : Int?
    var weight : Double?
    var orm : Double?
    var percentORM : Int?
    var breakTime : Int?
}

extension Workout {
    
    static func transformExerciseTarget(data: [String: Any], key: String) -> ExerciseTarget {
        var target = ExerciseTarget()
        target.id = key
        target.set = data["set"] as? Int
        target.reps = data["reps"] as? Int
        target.weight = data["weight"] as? Double
        target.breakTime = data["breakTime"] as? Int
        return target
        
    }
}

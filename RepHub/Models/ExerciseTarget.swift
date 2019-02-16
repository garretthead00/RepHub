//
//  ExerciseTarget.swift
//  RepHub
//
//  Created by Garrett Head on 2/9/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class ExerciseTarget {
    var id : String?
    var set : Int?
    var reps : Int?
    var weight : Double?
    var orm : Double?
    var percentORM : Int?
}

extension ExerciseTarget {
    
    static func transformExerciseTarget(data: [String: Any], key: String) -> ExerciseTarget {
        let target = ExerciseTarget()
        target.id = key
        target.set = data["set"] as? Int
        target.reps = data["reps"] as? Int
        target.weight = data["weight"] as? Double
        return target
        
    }
}

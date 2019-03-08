//
//  ExerciseLog.swift
//  RepHub
//
//  Created by Garrett Head on 9/9/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class ExerciseLog {
    
    var id : String?
    var reps : Int?
    var weight : Double?
    var weightKG : Double?
    var set : Int?
}

extension ExerciseLog {
    
    static func transformExerciseLog(data: [String: Any], key: String) -> ExerciseLog {
        let log = ExerciseLog()
        log.id = key
        log.set = data["set"] as? Int
        log.reps = data["reps"] as? Int
        log.weight = data["weight"] as? Double
        return log
    }
}

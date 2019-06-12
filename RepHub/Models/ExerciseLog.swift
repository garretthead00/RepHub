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
    var value : Int?
    var weightLB : Double?
    var weightKG : Double?
    var set : Int?
    var workoutExerciseId: String?
    var metricUnit: String?
    var score: Double?
    
}

extension ExerciseLog {
    
    static func transformExerciseLog(data: [String: Any], key: String) -> ExerciseLog {
        let log = ExerciseLog()
        log.id = key
        log.set = data["set"] as? Int
        log.value = data["value"] as? Int
        log.weightLB = data["weightLB"] as? Double
        log.metricUnit = data["metricUnit"] as? String
        log.workoutExerciseId = data["workoutExerciseId"] as? String
        log.score = 0.0
        return log
    }
}

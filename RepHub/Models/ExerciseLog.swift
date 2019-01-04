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
    var exerciseId: String?
    var timestamp : Int?
    var reps : Int?
    var weightLBS : Double?
    var weightKG : Double?
    var distanceKM : Double?
    var distanceMI : Double?
    var timeElapsed : Int?
}

extension ExerciseLog {
    
    static func transformExerciseLog(data: [String: Any], key: String) -> ExerciseLog {
        let log = ExerciseLog()
        log.id = key
        log.exerciseId = data["exerciseId"] as? String
        log.timestamp = data["timestamp"] as? Int
        log.reps = data["reps"] as? Int
        log.weightKG = data["weightKG"] as? Double
        log.weightLBS = data["weightLBS"] as? Double
        log.distanceKM = data["distanceKM"] as? Double
        log.distanceMI = data["distanceMI"] as? Double
        log.timeElapsed = data["time-elapsed"] as? Int
        return log
    }
}

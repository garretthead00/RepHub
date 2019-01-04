//
//  WorkoutLog.swift
//  RepHub
//
//  Created by Garrett Head on 9/12/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class WorkoutLog {
    
    var id : String?
    var timestamp : Int?
    var workoutId : String?
    var duration : Int?
    var totalWork : Float?
    var totalDistance : Float?
    var totalReps : Int?
    var totalCalories : Float?
    var totalSteps: Int?
    
}

extension WorkoutLog {
 
    static func transformWorkoutLog(data: [String : Any], key: String) -> WorkoutLog {
        let log = WorkoutLog()
        log.id = key
        log.workoutId = data["workoutId"] as? String
        log.timestamp = data["timestamp"] as? Int
        log.totalCalories = data["totalCalories"] as? Float
        log.duration = data["duration"] as? Int
        log.totalDistance = data["totalDistance"] as? Float
        log.totalReps = data["totalReps"] as? Int
        log.totalWork = data["totalWork"] as? Float
        log.totalSteps = data["totalSteps"] as? Int
        return log
    }
    
}

//
//  WorkoutExercises.swift
//  RepHub
//
//  Created by Garrett Head on 9/8/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class WorkoutExercise {
    
    var id : String?
    var atIndex : Int?
    var exerciseId : String?
    var name : String?
    var breakTime : Int?
    var sets : Int?
    var target : Int?
    var metricUnit : String?
    var metricType: String?
    var logs : [ExerciseLog]?
    
    // Will be removing
    var targets : [ExerciseTarget]?
    
}

extension WorkoutExercise {
    
    static func transformWorkoutExercise(data: [String: Any], key: String) -> WorkoutExercise {
        let workoutExercise = WorkoutExercise()
        workoutExercise.id = key
        workoutExercise.exerciseId = data["exerciseId"] as? String
        workoutExercise.breakTime = data["breakTime"] as? Int
        workoutExercise.atIndex = data["atIndex"] as? Int
        workoutExercise.target = data["target"] as? Int
        workoutExercise.sets = data["sets"] as? Int
        workoutExercise.metricUnit = data["metricUnit"] as? String
        workoutExercise.metricType = ""
        workoutExercise.name = ""
        workoutExercise.targets = [ExerciseTarget]()
        workoutExercise.logs = [ExerciseLog]()

        return workoutExercise
    }
}

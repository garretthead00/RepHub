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
    var exerciseId : String?
    var breakTime : Int?
    var targets : [ExerciseTarget]?
    var atIndex : Int?
    var logs : [ExerciseLog]?
    
}

extension WorkoutExercise {
    
    static func transformWorkoutExercise(data: [String: Any], key: String) -> WorkoutExercise {
        let workoutExercise = WorkoutExercise()
        workoutExercise.id = key
        workoutExercise.exerciseId = data["exerciseId"] as? String
        workoutExercise.breakTime = data["break"] as? Int
        workoutExercise.atIndex = data["atIndex"] as? Int
        workoutExercise.targets = [ExerciseTarget]()
        workoutExercise.logs = [ExerciseLog]()
        return workoutExercise
    }
}

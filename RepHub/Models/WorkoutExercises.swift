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
    var breakTime : String?
    var targets : [ExerciseTarget]?
    
}

extension WorkoutExercise {
    
    static func transformWorkoutExercise(data: [String: Any], key: String) -> WorkoutExercise {
        let workoutExercise = WorkoutExercise()
        workoutExercise.id = key
        workoutExercise.exerciseId = data["exerciseId"] as? String
        workoutExercise.breakTime = data["breakTime"] as? String
        workoutExercise.targets = [ExerciseTarget]()
        return workoutExercise
    }
}

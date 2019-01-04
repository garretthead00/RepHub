//
//  WorkoutExercisesAPI.swift
//  RepHub
//
//  Created by Garrett Head on 8/17/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class WorkoutExercisesAPI {
    
    var WORKOUT_EXERCISES_DB_REF = Database.database().reference().child("workout-exercises")
    
    func observeWorkoutExercises(withId id: String, completion: @escaping(WorkoutExercise) -> Void) {
        WORKOUT_EXERCISES_DB_REF.child(id).queryOrdered(byChild: "atIndex").observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let workoutExercise = WorkoutExercise.transformWorkoutExercise(data: data, key: snapshot.key)
                completion(workoutExercise)
            }
        })
    }
    

}

//
//  WorkoutExerciseLogsAPI.swift
//  RepHub
//
//  Created by Garrett on 3/4/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class WorkoutExerciseLogsAPI {
    
    var WORKOUT_EXERCISE_LOGS_DB_REF = Database.database().reference().child("workout-exercise-logs")
    
    func createWorkoutExerciseLog(workoutLogId: String, workoutExerciseId: String, logId: String) {
        WORKOUT_EXERCISE_LOGS_DB_REF.child(workoutLogId).child(workoutExerciseId).child(logId).setValue(true)
    }
    
    func observeWorkoutExerciseLogs(workoutLogId: String, workoutExerciseId: String, completion: @escaping(ExerciseLog) -> Void){
        print("Here I AM")
        WORKOUT_EXERCISE_LOGS_DB_REF.child(workoutLogId).child(workoutExerciseId).observe(.childAdded, with: {
            snapshot in
            if let key = snapshot.key as? String {
                print("snapshot.key: \(key)")
                API.ExerciseLog.obeserveExerciseLogs(withId: key, completion: {
                    log in
                    completion(log)
                })
            }

        })
        
    }
    
}

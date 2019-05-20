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
        WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").queryOrdered(byChild: "atIndex").observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let workoutExercise = WorkoutExercise.transformWorkoutExercise(data: data, key: snapshot.key)
                completion(workoutExercise)
                
                
            }
        })
    }
    
    func removeWorkoutExercise(workoutId id: String, workoutExerciseId: String, onSuccess: @escaping(Bool) -> Void){
        WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").child(workoutExerciseId).removeValue(completionBlock: {
            err, ref in
            if err != nil {
                onSuccess(false)
            }
            onSuccess(true)
        })
    }
    
    func addWorkoutExercise(workoutId id: String, workoutExerciseId: String, atIndex: Int) {
        let newExerciseRef = WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").childByAutoId()
        newExerciseRef.setValue(["atIndex": atIndex, "exerciseId":workoutExerciseId])
    }
    
    func setBreak(workoutId id: String, workoutExerciseId: String, breakTime: Int, onSuccess: @escaping(Bool) -> Void) {
        let workoutExerciseRef = WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").child(workoutExerciseId)
        workoutExerciseRef.updateChildValues(["break": breakTime])
        workoutExerciseRef.updateChildValues(["break": breakTime], withCompletionBlock: {
            err, ref in
            if err != nil {
                onSuccess(false)
            }
            onSuccess(true)
            
        })
    }
    
    
    
    func setORM(workoutId id: String, workoutExerciseId: String, ORM: Int) {
        let workoutExerciseRef = WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").child(workoutExerciseId)
        workoutExerciseRef.updateChildValues(["ORM": ORM])
    }

}

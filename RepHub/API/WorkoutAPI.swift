//
//  WorkoutAPI.swift
//  RepHub
//
//  Created by Garrett Head on 8/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class WorkoutAPI {
    
    var WORKOUT_DB_REF = Database.database().reference().child("workouts")
    var WORKOUT_EXERCISES_DB_REF = Database.database().reference().child("workout-exercises")
    
    func observeUserWorkouts(withId id: String, completion: @escaping(Workout) -> Void) {
        WORKOUT_DB_REF.child(id).observe(.childAdded, with: { snapshot in
            if let data = snapshot.value as? [String : Any] {
                let workout = Workout.transformWorkout(data: data, key: snapshot.key)
                completion(workout)
            }
        })
    }
    
    func observeWorkout(withId id: String, completion: @escaping(Workout) -> Void) {
        WORKOUT_DB_REF.child(id).observeSingleEvent(of: .value, with: {
        snapshot in
            if let data = snapshot.value as? [String: Any] {
                //Pass songArray to the completion handler on the main thread.
                DispatchQueue.main.async() {
                    if !data.isEmpty {
                        let workout = Workout.transformWorkout(data: data, key: snapshot.key)
                        completion(workout)
                    }
                }
            }
        })
    }
    
    func getWorkoutNames(withId id: String, completion: @escaping([String : String]) -> Void){
        WORKOUT_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let workout = Workout.transformWorkout(data: data, key: snapshot.key)
                completion([id: workout.name!])
            }
        })
    }
    
    func observerExercisesForWorkout(withId id: String, completion: @escaping(WorkoutExercise) -> Void) {
        WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").queryOrdered(byChild: "atIndex").observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let exercise = WorkoutExercise.transformWorkoutExercise(data: data, key: snapshot.key)
                completion(exercise)
            }
        })
    }
    

}

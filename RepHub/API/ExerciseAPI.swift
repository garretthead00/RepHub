//
//  ExerciseAPI.swift
//  RepHub
//
//  Created by Garrett Head on 8/8/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ExerciseAPI {
    
    var EXERCISE_DB_REF = Database.database().reference().child("exercises")
    
    func observeExercises(completion: @escaping(Exercise) -> Void) {
        EXERCISE_DB_REF.observe(.childAdded, with: { snapshot in
            if let data = snapshot.value as? [String : Any] {
                let exercise = Exercise.transformExercise(data: data, key: snapshot.key)
                completion(exercise)
            }
        })
    }
    
    
    func observeExercises(ofType: String, completion: @escaping(Exercise) -> Void) {
        EXERCISE_DB_REF.queryOrdered(byChild: "exerciseType").queryEqual(toValue: ofType).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String : Any] {
                let exercise = Exercise.transformExercise(data: data, key: snapshot.key)
                completion(exercise)
            }
        })
    }
    
    func observeExercise(withId id: String, completion: @escaping(Exercise) -> Void) {
        EXERCISE_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String : Any] {
                let exercise = Exercise.transformExercise(data: data, key: snapshot.key)
                completion(exercise)
            }
        })
        
    }
    
}


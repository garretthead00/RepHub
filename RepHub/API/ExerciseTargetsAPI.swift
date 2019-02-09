//
//  ExerciseTargetsAPI.swift
//  FirebaseAuth
//
//  Created by Garrett Head on 2/9/19.
//

import Foundation
import FirebaseDatabase

class ExerciseTargetsAPI {
    var EXERCISE_TARGETS_DB_REF = Database.database().reference().child("exercise-targets")
    
    func observeExerciseTarget(withId id: String, completion: @escaping(ExerciseTarget) -> Void) {
        EXERCISE_TARGETS_DB_REF.child(id).observeSingleEvent(.value, with: {
            snapshot in
            if let data = snapshow.value as? [String : Any] {
                let exerciseTarget = ExerciseTarget.transformExerciseTarget(data: data, key: snapshot.key)
                completion(exerciseTarget)
            }
        })
        
    }
    
}

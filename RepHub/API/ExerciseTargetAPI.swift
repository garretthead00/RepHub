//
//  ExerciseTargetsAPI.swift
//  FirebaseAuth
//
//  Created by Garrett Head on 2/9/19.
//

import Foundation
import FirebaseDatabase

class ExerciseTargetAPI {
    var EXERCISE_TARGETS_DB_REF = Database.database().reference().child("exercise-targets")
    
    func observeExerciseTarget(withId id: String, completion: @escaping(ExerciseTarget) -> Void) {
        EXERCISE_TARGETS_DB_REF.child(id).child("targets").queryOrdered(byChild: "set").observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String : Any] {
                let exerciseTarget = ExerciseTarget.transformExerciseTarget(data: data, key: snapshot.key)
                completion(exerciseTarget)
            }
        })
        
    }
    

    func addTarget(withWorkoutExerciseId id: String, set: Int, reps: Int, weight: Double) {
        let newTargetRef = API.ExerciseTarget.EXERCISE_TARGETS_DB_REF.child(id).child("targets").childByAutoId()
        newTargetRef.setValue(["set": set, "reps": reps, "weight": weight])
    }
    
    func editTarget(withWorkoutExerciseId id: String, targetId: String, reps: Int, weight: Double,onSuccess: @escaping (Bool) -> Void) {
        let editTargetRef = API.ExerciseTarget.EXERCISE_TARGETS_DB_REF.child(id).child("targets").child(targetId)
        editTargetRef.updateChildValues(["reps" : reps, "weight" : weight], withCompletionBlock: {
            err, ref in
            if err != nil {
                ProgressHUD.showError(err!.localizedDescription)
                onSuccess(false)
            }
            onSuccess(true)
        })
    }

}

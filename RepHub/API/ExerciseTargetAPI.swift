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
        let targetRef = EXERCISE_TARGETS_DB_REF.child(id).queryOrdered(byChild: "set")
        targetRef.observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String : Any] {
                let exerciseTarget = ExerciseTarget.transformExerciseTarget(data: data, key: snapshot.key)
                //print("exerciseTarget: \(exerciseTarget)")
                completion(exerciseTarget)
            }
        })
    }

    func addTarget(withWorkoutExerciseId id: String, set: Int, reps: Int, weight: Double) {
        let newTargetRef = EXERCISE_TARGETS_DB_REF.child(id).childByAutoId()
        newTargetRef.setValue(["set": set, "reps": reps, "weight": weight])
    }
    
    func editTarget(withWorkoutExerciseId id: String, targetId: String, reps: Int, weight: Double) {
        let editTargetRef = EXERCISE_TARGETS_DB_REF.child(id).child(targetId)
        editTargetRef.updateChildValues(["reps" : reps, "weight" : weight], withCompletionBlock: {
            err, ref in
            if err != nil {
                ProgressHUD.showError(err!.localizedDescription)
            }
        })
    }
    
    func removeTarget(withWorkoutExerciseId id: String, targetId: String) {
       let removeTargetRef = EXERCISE_TARGETS_DB_REF.child(id).child(targetId)
        removeTargetRef.removeValue()
    }
    
    func removeAllTargets(withWorkoutExerciseId id: String, onSuccess: @escaping(Bool) -> Void) {
        EXERCISE_TARGETS_DB_REF.child(id).removeValue(completionBlock: {
            err, ref in
            if err != nil {
                onSuccess(false)
            }
            onSuccess(true)
        })
    }

}

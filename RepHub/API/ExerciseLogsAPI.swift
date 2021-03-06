//
//  ExerciseLogsAPI.swift
//  RepHub
//
//  Created by Garrett Head on 8/22/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ExerciseLogAPI {
    
    var EXERCISE_LOG_DB_REF = Database.database().reference().child("exercise-logs")
    
    func obeserveExerciseLogs(withId id: String, completion: @escaping (ExerciseLog) -> Void) {
        EXERCISE_LOG_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                print("sending log")
                let exerciseLog = ExerciseLog.transformExerciseLog(data: data, key: snapshot.key)
                completion(exerciseLog)
            }
        })
    }
    
    func createExerciseLog(withId id: String, set: Int, reps: Int, weight: Double, score: Double, metricUnit: String, workoutExerciseId: String) {
        
        let newRef = EXERCISE_LOG_DB_REF.child(id).childByAutoId()
        let timestamp = NSDate().timeIntervalSince1970
        newRef.setValue(["set": set, "reps": reps, "weight" : weight, "metricUnit" : metricUnit, "timestamp": timestamp, "workoutExerciseId": workoutExerciseId, "score": score], withCompletionBlock: {
            error, ref in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
        })
        
    }
    
    
    
    
}

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
        EXERCISE_LOG_DB_REF.child(id).queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let exerciseLog = ExerciseLog.transformExerciseLog(data: data, key: snapshot.key)
                completion(exerciseLog)
            }
        })
    }
}

//
//  WorkoutLogsAPI.swift
//  RepHub
//
//  Created by Garrett Head on 9/12/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class WorkoutLogsAPI {
    
    var WORKOUT_LOGS_DB_REF = Database.database().reference().child("workout-logs")
    
    func observeWorkoutLogs(completion: @escaping(WorkoutLog) -> Void) {
        WORKOUT_LOGS_DB_REF.observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let workoutLog = WorkoutLog.transformWorkoutLog(data: data, key: snapshot.key)
                completion(workoutLog)
            }
        })
    }
    
    func observeWorkoutLog(withId id: String, completion: @escaping(WorkoutLog) -> Void){
        WORKOUT_LOGS_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let log = WorkoutLog.transformWorkoutLog(data: data, key: snapshot.key)
                completion(log)
            }
        })
    }
    
    func createNewWorkoutLog(withId id: String, workoutDurationSeconds: Double, totalReps: Int, totalDistance: Double, totalSteps: Int, energyBurned: Double, totalWork: Double, completion: @escaping(Bool) -> Void) {
        WORKOUT_LOGS_DB_REF.child(id).setValue(["duration": workoutDurationSeconds, "totalReps": totalReps, "totalWork": totalWork, "totalSteps": totalSteps, "totalCalories": energyBurned, "totalDistance" : totalDistance], withCompletionBlock: {
            error, ref in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            completion(true)
            
        })
        
    }
    
}

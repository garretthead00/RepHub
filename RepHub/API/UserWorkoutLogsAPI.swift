//
//  UserWorkoutLogsAPI.swift
//  RepHub
//
//  Created by Garrett Head on 9/12/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserWorkoutLogsAPI {
    
    var USER_WORKOUT_LOGS_DB_REF = Database.database().reference().child("user-workout-logs")
    
    func createUserWorkoutLog(withUserId id: String, workoutId: String, completion: @escaping(String) -> Void){
        let newRef = USER_WORKOUT_LOGS_DB_REF.child(id).child(workoutId).childByAutoId()
        let timestamp = NSDate().timeIntervalSince1970
        newRef.setValue(timestamp, withCompletionBlock: {
            err, ref in
            if err != nil {
                ProgressHUD.showError(err?.localizedDescription)
            }
            completion(newRef.key)
        })
    }
    
}

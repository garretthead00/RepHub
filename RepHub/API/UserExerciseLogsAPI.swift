//
//  UserExerciseLogsAPI.swift
//  RepHub
//
//  Created by Garrett Head on 8/22/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserExerciseLogsAPI {
    
    var USER_EXERCISE_LOGS_DB_REF = Database.database().reference().child("user-exercise-logs")
    
    func createExerciseLog(withId id: String, completion: @escaping(String) -> Void){
        guard let currentuser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let newExerciseLogRef = USER_EXERCISE_LOGS_DB_REF.child(currentuser.uid).child(id).childByAutoId()
        let timestamp = NSDate().timeIntervalSince1970
        newExerciseLogRef.setValue(timestamp, withCompletionBlock: {
            err, ref in
            if err != nil {
                return
            }
            completion(newExerciseLogRef.key!)
        })
        
    }
    
}

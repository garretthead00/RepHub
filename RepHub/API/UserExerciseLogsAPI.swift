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
    
}

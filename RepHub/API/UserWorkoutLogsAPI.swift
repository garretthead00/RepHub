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
    
}

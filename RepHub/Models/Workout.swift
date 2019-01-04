//
//  Workout.swift
//  RepHub
//
//  Created by Garrett Head on 8/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit


struct Workout {
    
    var id : String?
    var name : String?
    var description : String?
}

extension Workout {
    static func transformWorkout(data: [String: Any], key: String) -> Workout {
        var workout = Workout()
        workout.id = key
        workout.name = data["name"] as? String
        workout.description = data["description"] as? String
        return workout
    }
}



//
//  Exercise.swift
//  RepHub
//
//  Created by Garrett Head on 8/8/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class Exercise {
    
    var id: String?
    var name: String?
    var force: String?
    var joint : String?
    var modality : String?
    var muscleGroup: String?
    var region: String?
    var section : String?
    var exerciseType: String?
    var targetSets: Int?
    var targetReps: Int?
    var breakTime: String?
    
}

extension Exercise {
    
    static func transformExercise(data: [String: Any], key: String) -> Exercise {
        let exercise = Exercise()
        exercise.id = key
        exercise.name = data["name"] as? String
        exercise.muscleGroup = data["muscle group"] as? String
        exercise.force = data["force"] as? String
        exercise.region = data["region"] as? String
        exercise.section = data["section"] as? String
        exercise.joint = data["joint"] as? String
        exercise.modality = data["modality"] as? String
        exercise.exerciseType = data["exercise type"] as? String
        return exercise
    }
    
    
}

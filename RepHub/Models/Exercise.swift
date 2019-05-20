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
    var description: String?
    var modality: String?
    var muscleGroup: [String]?
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
        exercise.description = data["description"] as? String
        exercise.muscleGroup = data["muscleGroup"] as? [String]
        exercise.modality = data["modality"] as? String
        exercise.exerciseType = data["exerciseType"] as? String
        return exercise
    }
    
    
}

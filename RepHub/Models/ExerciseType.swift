//
//  ExerciseType.swift
//  RepHub
//
//  Created by Garrett Head on 3/27/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation



enum ExerciseType: Int {
    case circuit, endurance, strength, isometric, flexibility, breathing, agility, sport

    static let typeNames = [circuit : "Circuit", endurance : "Endurance", strength : "Strength", isometric: "Isometric", flexibility: "Flexibility", breathing: "Breathing", agility: "Agility", sport: "Sport"]
    static let identifiers = [circuit : "MuscleGroups", endurance : "ExerciseGroup", strength : "MuscleGroups", isometric: "MuscleGroups", flexibility: "MuscleGroups", breathing: "ExerciseGroup", agility: "ExerciseGroup", sport: "ExerciseGroup"]

    func typeName() -> String {
        if let typeName = ExerciseType.typeNames[self] {
            return typeName
        } else {
            return ""
        }
    }
    
    func identifierName() -> String {
        if let identifier = ExerciseType.identifiers[self] {
            return identifier
        } else {
            return ""
        }
    }

    func numberOfExerciseTypes() -> Int { return ExerciseType.typeNames.count }
}


//
//  MuscleGroup.swift
//  RepHub
//
//  Created by Garrett Head on 3/30/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation


enum MuscleGroup: Int {
    case chest, legs, biceps, triceps, shoulders, abdominals, back, lowerBack, calves
    
    static let groupNames = [chest : "Chest", legs : "Legs", shoulders : "Shoulders", abdominals: "Abdominals", back: "Back", lowerBack : "Lower Back", triceps: "Triceps", biceps: "Biceps", calves: "Calves"]
    
    func groupName() -> String {
        if let groupName = MuscleGroup.groupNames[self] {
            return groupName
        } else {
            return ""
        }
    }
    
    func getIdentifier() -> String { return "ExerciseGroup" }
    func numberOfMuscleGroups() -> Int { return 6 }
}


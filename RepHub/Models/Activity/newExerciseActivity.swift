//
//  newExerciseActivity.swift
//  RepHub
//
//  Created by Garrett Head on 1/25/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import Foundation

struct newExerciseActivity : Activity {
    var name: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    
    var dailyTotal: Double?
    var remainingToTarget: Double?
    var target: Double?
    var percentComplete: Double?
    var percentRemaining: Double?
    var summaryData: [(String, Double, String)]?
    
    lazy var totalActiveCaloriesBurned : Double? = {
        return 0.0
    }()
    
    lazy var totalSteps : Double = {
        return 0.0
    }()
    
    lazy var exerciseMinutes : Double = {
        return 0.0
    }()
    lazy var workoutsCompleted : Double = {
        return 0.0
    }()
    
}

extension newExerciseActivity {
    
    init(){
        self.name = "Exercise"
        self.icon = UIImage.Theme.Activity.exercise
        self.color = UIColor.Theme.Activity.exercise
        self.unit = "Calories"
        self.target = 630.0
        self.dailyTotal = 432.0
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
    }
    
    init(logs: [WorkoutLog]){
        self.name = "Exercise"
        self.icon = UIImage.Theme.Activity.exercise
        self.color = UIColor.Theme.Activity.exercise
        self.unit = "Calories"
        self.target = 630.0
    }
    
}

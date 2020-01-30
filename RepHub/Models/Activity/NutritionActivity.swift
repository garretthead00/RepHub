//
//  NutritionActivity.swift
//  RepHub
//
//  Created by Garrett Head on 1/29/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import Foundation

struct NutritionActivity: Activity {
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
    
    var logs : [NutritionLog] = []
    
    // MARK: Nutrition
    var energyConsumed : Double {
        return self.nutritionTotalizer(forNutrient: Nutrients.Energy.rawValue)
    }
    var protein : Double {
        return self.nutritionTotalizer(forNutrient: Nutrients.Protein.rawValue)
    }
    var fats : Double {
        return self.nutritionTotalizer(forNutrient: Nutrients.Fat.rawValue)
    }
    var carbohydrates : Double {
        return self.nutritionTotalizer(forNutrient: Nutrients.Carbs.rawValue)
    }
    
    mutating func refreshLogs(logs: [NutritionLog]){
        self.logs.removeAll()
        self.logs = logs
    }
}

extension NutritionActivity {

    init(){
        self.name = "Nutrition"
        self.icon = UIImage.Theme.Activity.eat
        self.color = UIColor.Theme.Activity.eat
        self.unit = "Calories"
        self.target = 1600.0
        self.dailyTotal = 0.0
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
    }
    
    private func nutritionTotalizer(forNutrient nutrient: String) -> Double{
        var sum = 0.0
        for log in self.logs{
            if let nutrition = log.nutrition, nutrition.count > 0 {
                sum += nutrition.filter({$0.name == nutrient}).map({$0.value!}).reduce(0, +)
            }
        }
        return sum
    }
}

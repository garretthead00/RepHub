//
//  HydrateActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

struct HydrateActivity: Activity {
    var name: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    
    var dailyTotal: Double?
    var remainingToTarget: Double?
    var target: Double?
    var percentComplete: Double?
    var percentRemaining: Double?
    var logs : [NutritionLog] = []
    var summaryData: [(String, Double, String)]?
    
    
    // MARK: Nutrition
    var totalCaffeine : Double {
        return self.nutritionTotalizer(forNutrient: Nutrients.Caffeine.rawValue)
    }
    var totalWater : Double {
        var sum = 0.0
        // iterate through the logs and sum the values on the nutrient map.
        for log in self.logs {
            if let food = log.food, let type = food.category{
                if let serving = log.householdServingSize, type == "Water" {
                    sum += serving
                }
            }
        }
        return sum
    }
    var totalFluids : Double {
        var sum = 0.0
        // iterate through the logs and sum the values on the nutrient map.
        for log in self.logs{
            if let serving = log.householdServingSize {
                sum += serving
            }
        }
        return sum
    }
    var totalSugar : Double {
        print("totalSugar \(Nutrients.Sugar.rawValue)")
        return self.nutritionTotalizer(forNutrient: Nutrients.Sugar.rawValue)
    }
    
    mutating func refreshLogs(logs: [NutritionLog]){
        self.logs.removeAll()
        self.logs = logs
    }
    
}

extension HydrateActivity {
    
    init() {
        self.name = "Hydration"
        self.icon = UIImage.Theme.Activity.hydrate
        self.color = UIColor.Theme.Activity.hydrate
        self.unit = "fl oz"
        self.target = 64.0
        self.dailyTotal = 0.0
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
        
    }
    
    init(logs: [NutritionLog]) {
        self.name = "Hydration"
        self.icon = UIImage.Theme.Activity.hydrate
        self.color = UIColor.Theme.Activity.hydrate
        self.unit = "fl oz"
        self.target = 64.0
        self.dailyTotal = 0.0
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
        self.logs = logs
        
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

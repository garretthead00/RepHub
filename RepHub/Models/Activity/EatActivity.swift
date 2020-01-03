//
//  EatActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

enum Nutrients : String {
    case Energy = "Calories"
    case Protein = "Protein"
    case Carbs = "Carbohydrate"
    case Fat = "Fat"
    case Sugar = "Sugar"
    case Water = "Water"
    case Caffeine = "Caffeine"
    case Sodium = "Sodium"
    case Fiber = "Fiber"
    case Cholesterol = "Cholesterol"
}

class EatActivity : Activity {

    
    var label: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    var dailyTotal: Double?
    var target: Double?
    var percentComplete: Double?
    var percentRemaining: Double?
    var data: [(String, Double, String)] = []
    var summaryData: [(String, Double, String)] = []
    var logs : [FoodLog] = []
    // var nutritionLogs : [[NutritionLog]] = []
    
    
    // MARK: Nutrition
    var totalEnergyConsumed : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Energy.rawValue)
    }
    var totalProtein : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Protein.rawValue)
    }
    var totalFat : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Fat.rawValue)
    }
    var totalCarbs : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Carbs.rawValue)
    }
    var totalFiber : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Fiber.rawValue)
    }
    var totalCholesterol : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Cholesterol.rawValue)
    }
    var totalSodium : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Sodium.rawValue)
    }
    var totalSugar : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Sugar.rawValue)
    }
    
    
    init() {
        self.label = "Eat"
        self.icon = UIImage.Theme.Activity.eat
        self.color = UIColor.Theme.Activity.eat
        self.unit = "Calories"
        self.target = 1600.0

        self.summaryData = [
           ("Protein", 0.0, "g"),
           ("Fat", 0.0, "g"),
           ("Carbs", 0.0, "g")
        ]
        
        self.data = [
           ("Protein", 0.0, "g"),
           ("Fat", 0.0, "g"),
           ("Carbs", 0.0, "g")
        ]
        self.calculateProgress()
        
    }
}

extension EatActivity {
    
    private func calculateProgress(){
//        let sum = self.logs.map({$0.servingSize!}).reduce(0, +)//.filter({$0.drink!.category == "Water"}).map({$0.servingSize!}).reduce(0, +)
//        self.dailyTotal = sum
//
        self.dailyTotal = 680.0
        let dailyTotal = self.dailyTotal ?? 0.0
        self.percentComplete = dailyTotal / self.target! * 100
        self.percentRemaining = 100.0 - self.percentComplete!
        print("total food: \(dailyTotal)")
    }
    
    private func getFoodLogs(){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid

        API.UserFoodLog.observeFoodLogs(withId: currentUserId, completion: {
            log in
            self.logs.append(log)
            if self.logs.count > 0 {
                self.logs = self.logs.sorted(by: { $0.timestamp! > $1.timestamp!})
            }
            //print("food log -- : \(log.servingSize) \(log.servingSizeUnit) @ \(log.timestamp)")
            self.calculateProgress()
        })
    }
    
    private func nutritionTotalizer(forNutrient nutrient: String) -> Double{
        var sum = 0.0
        // iterate through the logs and sum the values on the nutrient map.
        return sum
    }
    
}

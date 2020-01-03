//
//  HydrateActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

class HydrateActivity: Activity {

    
    
    var label: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    var dailyTotal: Double?
    var target: Double?
    var percentComplete: Double?
    var percentRemaining: Double?
    var data: [(String, Double, String)] {
        return [
            ("Caffeine", self.totalCaffeine, "mg"),
            ("Sugar", self.totalSugar, "mg"),
            ("Water", self.totalWater, "mg")
        ]
    }
    var summaryData: [(String, Double, String)] {
        return [
            ("Drank", self.dailyTotal ?? 0.0, "oz"),
            ("Sugar", self.totalSugar, "mg"),
            ("Caffeine", self.totalCaffeine, "mg")
        ]
    }
    var logs : [HydrateLog] = [] {
        didSet{
            self.calculateProgress()
        }
    }
    var nutrition : [(String, Double, String)] = []
    
    
    // MARK: Nutrition
    var totalEnergyConsumed : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Energy.rawValue)
    }
    var totalCaffeine : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Caffeine.rawValue)
    }
    var totalWater : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Water.rawValue)
    }
    var totalFluids : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Water.rawValue)
    }
    var totalSugar : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Sugar.rawValue)
    }
    var totalSodium : Double {
        return nutritionTotalizer(forNutrient: Nutrients.Sodium.rawValue)
    }

    
    init() {
        self.label = "Hydrate"
        self.icon = UIImage.Theme.Activity.hydrate
        self.color = UIColor.Theme.Activity.hydrate
        self.unit = "fl oz"
        self.target = 64.0
        self.getTodaysLogs()
        
    }
}

extension HydrateActivity {
    

    private func calculateProgress(){
        let sum = self.logs.map({$0.servingSize!}).reduce(0, +)//.filter({$0.drink!.category == "Water"}).map({$0.servingSize!}).reduce(0, +)
        self.dailyTotal = sum
        let dailyTotal = self.dailyTotal ?? 0.0
        self.percentComplete = dailyTotal / self.target! * 100
        self.percentRemaining = 100.0 - self.percentComplete!
        print("total Water: \(sum)")
    }
    
    private func getTodaysLogs(){
        // fetch Hydrate Logs
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        API.Hydrate.observeHydrateLogs(withId: currentUserId, completion:  {
            log in

            if let logId = log.id {
                API.Nutrition.observeNutritionLog(forUserId: currentUserId, logId: logId, completion: {
                    nutrient in
                    if let name = nutrient.name, let value = nutrient.value, let unit = nutrient.unit {
                        log.nutrition?.append((name, value, unit))
                    }
                    
                })
                self.logs.append(log)
                if self.logs.count > 0 {
                    self.logs = self.logs.sorted(by: { $0.timestamp! > $1.timestamp!})
                }
            }

        })
    }
    
    private func nutritionTotalizer(forNutrient nutrient: String) -> Double{
        var sum = 0.0
        // iterate through the logs and sum the values on the nutrient map.
        for log in self.logs{
            if let nutrition = log.nutrition {
                sum += nutrition.filter({$0.0 == nutrient}).map({$0.1}).reduce(0, +)
            }
            
        }
        return sum
    }
    

}

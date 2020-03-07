//
//  HydrateActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

struct HydrationActivity: Activity {
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
    var macros : [(String, Double, Double, String)]?
    var electrolytes: [(String, Double, Double, String)]?
    var otherNutrients : [(String, Double, Double, String)]?
    
    // MARK: Nutrition
    var totalWater : Double? {
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
    var totalFluids : Double? {
        var sum = 0.0
        // iterate through the logs and sum the values on the nutrient map.
        for log in self.logs{
            if let serving = log.householdServingSize {
                sum += serving
            }
        }
        return sum
    }
    
    var totalEnergyConsumed : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Energy.rawValue) }
    var totalProtein : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Protein.rawValue) }
    var totalFats : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Fat.rawValue) }
    var totalCarbohydrates : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Carbs.rawValue) }
    var totalSugar : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Sugar.rawValue) }
    var totalFiber : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Fiber.rawValue) }
    var totalCalcium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Calcium.rawValue) }
    var totalChloride : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Chloride.rawValue) }
    var totalMagnesium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Magnesium.rawValue) }
    var totalPhosphorus : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Phosphorus.rawValue) }
    var totalPotassium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Potassium.rawValue) }
    var totalSodium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Sodium.rawValue) }
    var totalCaffeine : Double? { return nutritionTotalizer(forNutrient: Nutrients.Caffeine.rawValue) }
    
    
    var energyConsumed : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Energy.rawValue) }
    var protein : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Protein.rawValue) }
    var fats : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Fat.rawValue) }
    var carbohydrates : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Carbs.rawValue) }
    var sugar : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Sugar.rawValue) }
    var fiber : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Fiber.rawValue) }
    var calcium : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Calcium.rawValue) }
    var chloride : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Chloride.rawValue) }
    var magnesium : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Magnesium.rawValue) }
    var phosphorus : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Phosphorus.rawValue) }
    var potassium : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Potassium.rawValue) }
    var sodium : Double? { return self.nutritionTotalizerForDrinks(forNutrient: Nutrients.Sodium.rawValue) }
    var caffeine : Double? { return nutritionTotalizerForDrinks(forNutrient: Nutrients.Caffeine.rawValue) }
    
    mutating func refreshLogs(logs: [NutritionLog]){
        self.logs.removeAll()
        self.logs = logs
        self.summaryData = [(Nutrients.Caffeine.rawValue, self.totalCaffeine!, "mg"),(Nutrients.Sugar.rawValue, self.totalSugar!, "g"),(Nutrients.Fluids.rawValue, self.totalFluids!, "oz")]
        self.macros = [(Nutrients.Protein.rawValue, protein!, self.totalProtein!, "g"),
                       (Nutrients.Fat.rawValue, fats!, self.totalFats!, "g"),
                       (Nutrients.Carbs.rawValue, carbohydrates!, self.totalCarbohydrates!, "g")]
        
        self.electrolytes = [(Nutrients.Calcium.rawValue, calcium!, self.totalCalcium!, "mg"),
                        (Nutrients.Chloride.rawValue, chloride!, self.totalChloride!, "mg"),
                        (Nutrients.Magnesium.rawValue, magnesium!,self.totalMagnesium!, "mg"),
                        (Nutrients.Phosphorus.rawValue, phosphorus!,self.totalPhosphorus!, "mg"),
                        (Nutrients.Potassium.rawValue, potassium!, self.totalPotassium!, "mg"),
                        (Nutrients.Sodium.rawValue, sodium!, self.totalSodium!, "mg")]
        
        self.otherNutrients = [(Nutrients.Caffeine.rawValue, self.caffeine!, self.totalCaffeine!,  "mg"),
                               (Nutrients.Sugar.rawValue, self.sugar!, self.totalSugar!, "g"),
                               ("alcohol", 0.0, 0.0, "oz")]
        self.dailyTotal = self.totalWater!
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
        self.percentComplete = self.dailyTotal! / self.target! * 100
        self.percentRemaining = 100 - self.percentRemaining!
    }
    
}

extension HydrationActivity {
    
    init() {
        self.name = "Hydration"
        self.icon = UIImage.Theme.Activity.hydrate
        self.color = UIColor.Theme.Activity.hydrate
        self.unit = "fl oz"
        self.target = 64.0
        self.dailyTotal = 0.0
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
        self.percentComplete = 0.0
        self.percentRemaining = 0.0
        self.summaryData = [(Nutrients.Caffeine.rawValue, self.totalCaffeine!, "mg"),(Nutrients.Sugar.rawValue, self.totalSugar!, "g"),(Nutrients.Fluids.rawValue, self.totalFluids!, "oz")]
        self.macros = [(Nutrients.Protein.rawValue, protein!, self.totalProtein!, "g"),
                       (Nutrients.Fat.rawValue, fats!, self.totalFats!, "g"),
                       (Nutrients.Carbs.rawValue, carbohydrates!, self.totalCarbohydrates!, "g")]
        
        self.electrolytes = [(Nutrients.Calcium.rawValue, calcium!, self.totalCalcium!, "mg"),
                        (Nutrients.Chloride.rawValue, chloride!, self.totalChloride!, "mg"),
                        (Nutrients.Magnesium.rawValue, magnesium!,self.totalMagnesium!, "mg"),
                        (Nutrients.Phosphorus.rawValue, phosphorus!,self.totalPhosphorus!, "mg"),
                        (Nutrients.Potassium.rawValue, potassium!, self.totalPotassium!, "mg"),
                        (Nutrients.Sodium.rawValue, sodium!, self.totalSodium!, "mg")]
        
        self.otherNutrients = [(Nutrients.Caffeine.rawValue, self.caffeine!, self.totalCaffeine!,  "mg"),
                               (Nutrients.Sugar.rawValue, self.sugar!, self.totalSugar!, "g"),
                               ("alcohol", 0.0, 0.0, "oz")]
        
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
    
    private func nutritionTotalizerForDrinks(forNutrient nutrient: String) -> Double{
        var sum = 0.0
        for log in self.logs {
            if let food = log.food {
                if food.foodGroup == "Drinks" {
                    if let nutrition = log.nutrition, nutrition.count > 0 {
                        sum += nutrition.filter({$0.name == nutrient}).map({$0.value!}).reduce(0, +)
                    }
                }
            }
        }
        return sum
    }
    

}

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
    var macros : [(String, Double, String)]?
    var vitamins :[(String, Double, Double, String)]?
    var minerals : [(String, Double, Double, String)]?
    var ultraTraceMinerals :[(String, Double, Double, String)]?
    var otherNutrients : [(String, Double, Double, String)]?
    
    // MARK: Nutrition
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

        
        self.summaryData = [(Nutrients.Protein.rawValue, self.totalProtein!, "g"),(Nutrients.Carbs.rawValue, self.totalCarbohydrates!, "g"),(Nutrients.Fat.rawValue, self.totalFats!, "g")]
        self.macros = [(Nutrients.Protein.rawValue, self.totalProtein!, "g"),
                       (Nutrients.Fat.rawValue,self.totalFats!, "g"),
                       (Nutrients.Carbs.rawValue,self.totalCarbohydrates!, "g")]

        self.minerals = [(Nutrients.Calcium.rawValue, calcium!, self.totalCalcium!, "mg"),
        (Nutrients.Chloride.rawValue, chloride!, self.totalChloride!, "mg"),
        (Nutrients.Magnesium.rawValue, magnesium!,self.totalMagnesium!, "mg"),
        (Nutrients.Phosphorus.rawValue, phosphorus!,self.totalPhosphorus!, "mg"),
        (Nutrients.Potassium.rawValue, potassium!, self.totalPotassium!, "mg"),
        (Nutrients.Sodium.rawValue, sodium!, self.totalSodium!, "mg")]
        
        self.dailyTotal = self.totalEnergyConsumed
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
        self.percentComplete = self.dailyTotal! / self.target! * 100
        self.percentRemaining = 100 - self.percentRemaining!
        
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
        self.remainingToTarget = 0.0
        self.percentComplete = 0.0
        self.percentRemaining = 0.0
        self.summaryData = [(Nutrients.Protein.rawValue, self.totalProtein!, "g"),(Nutrients.Carbs.rawValue, self.totalCarbohydrates!, "g"),(Nutrients.Fat.rawValue, self.totalFats!, "g")]
        self.macros = [(Nutrients.Protein.rawValue, self.totalProtein!, "g"),
                       (Nutrients.Fat.rawValue,self.totalFats!, "g"),
                       (Nutrients.Carbs.rawValue,self.totalCarbohydrates!, "g")]

        self.minerals = [(Nutrients.Calcium.rawValue, calcium!, self.totalCalcium!, "mg"),
        (Nutrients.Chloride.rawValue, chloride!, self.totalChloride!, "mg"),
        (Nutrients.Magnesium.rawValue, magnesium!,self.totalMagnesium!, "mg"),
        (Nutrients.Phosphorus.rawValue, phosphorus!,self.totalPhosphorus!, "mg"),
        (Nutrients.Potassium.rawValue, potassium!, self.totalPotassium!, "mg"),
        (Nutrients.Sodium.rawValue, sodium!, self.totalSodium!, "mg")]
        
       
        
        
    }
    
    func mark(){
        print("hey")
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
                if food.foodGroup != "Drinks" {
                    if let nutrition = log.nutrition, nutrition.count > 0 {
                        sum += nutrition.filter({$0.name == nutrient}).map({$0.value!}).reduce(0, +)
                    }
                }
            }
        }
        return sum
    }
}

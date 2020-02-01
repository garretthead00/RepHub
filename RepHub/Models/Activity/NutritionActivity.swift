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
    var vitamins : [(String, Double, String)]?
    var minerals : [(String, Double, String)]?
    var ultraTraceMinerals : [(String, Double, String)]?
    var otherNutrients : [(String, Double, String)]?
    
    // MARK: Nutrition
    var energyConsumed : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Energy.rawValue) }
    var protein : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Protein.rawValue) }
    var fats : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Fat.rawValue) }
    var carbohydrates : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Carbs.rawValue) }
    var totalCalcium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Calcium.rawValue) }
    var totalChloride : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Chloride.rawValue) }
    var totalMagnesium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Magnesium.rawValue) }
    var totalPhosphorus : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Phosphorus.rawValue) }
    var totalPotassium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Potassium.rawValue) }
    var totalSodium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Sodium.rawValue) }
    
    mutating func refreshLogs(logs: [NutritionLog]){
        self.logs.removeAll()
        self.logs = logs

        
        self.summaryData = [(Nutrients.Protein.rawValue, self.protein!, "g"),(Nutrients.Carbs.rawValue, self.carbohydrates!, "g"),(Nutrients.Fat.rawValue, self.fats!, "g")]
        self.macros = [(Nutrients.Protein.rawValue, self.protein!, "g"),
                       (Nutrients.Fat.rawValue,self.fats!, "g"),
                       (Nutrients.Carbs.rawValue,self.carbohydrates!, "g")]

        self.minerals = [(Nutrients.Calcium.rawValue, self.totalCalcium!, "mg"),
                         (Nutrients.Chloride.rawValue,self.totalChloride!, "mg"),
                         (Nutrients.Magnesium.rawValue,self.totalMagnesium!, "mg"),
                         (Nutrients.Phosphorus.rawValue,self.totalPhosphorus!, "mg"),
                         (Nutrients.Potassium.rawValue,self.totalPotassium!, "mg"),
                         (Nutrients.Sodium.rawValue,self.totalSodium!, "mg")]
        
        self.dailyTotal = self.energyConsumed
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
        self.summaryData = [(Nutrients.Protein.rawValue, self.protein!, "g"),(Nutrients.Carbs.rawValue, self.carbohydrates!, "g"),(Nutrients.Fat.rawValue, self.fats!, "g")]
        self.macros = [(Nutrients.Protein.rawValue, self.protein!, "g"),
                       (Nutrients.Fat.rawValue,self.fats!, "g"),
                       (Nutrients.Carbs.rawValue,self.carbohydrates!, "g")]

        self.minerals = [(Nutrients.Calcium.rawValue, self.totalCalcium!, "mg"),
                        (Nutrients.Chloride.rawValue,self.totalChloride!, "mg"),
                        (Nutrients.Magnesium.rawValue,self.totalMagnesium!, "mg"),
                        (Nutrients.Phosphorus.rawValue,self.totalPhosphorus!, "mg"),
                        (Nutrients.Potassium.rawValue,self.totalPotassium!, "mg"),
                        (Nutrients.Sodium.rawValue,self.totalSodium!, "mg")]
        
       
        
        
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
}

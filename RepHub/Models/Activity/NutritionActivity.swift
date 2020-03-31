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
    var lipids :[(String, Double, Double, String)]?
    var carbohydrates :[(String, Double, Double, String)]?
    var vitamins :[(String, Double, Double, String)]?
    var minerals : [(String, Double, Double, String)]?
    var ultraTraceMinerals :[(String, Double, Double, String)]?
    var otherNutrients : [(String, Double, Double, String)]?
    
    // MARK: Nutrition
    var totalEnergyConsumed : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Energy.rawValue) }
    
    // Macros
    var totalProtein : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Protein.rawValue) }
    var totalFats : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Fat.rawValue) }
    var totalCarbs : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Carbs.rawValue) }
    
    // Carbs
    var totalSugar : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Sugar.rawValue) }
    var totalFiber : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Fiber.rawValue) }
    
    // Lipids
    var totalCholesterol : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Cholesterol.rawValue) }
    var totalMonounsaturatedFat : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.MonounsaturatedFat.rawValue) }
    var totalPolyunsaturatedFat : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.PolyunsaturatedFat.rawValue) }
    var totalSaturatedFat : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.SaturatedFat.rawValue) }
    
    // Other
    var totalCaffeine : Double? { return nutritionTotalizer(forNutrient: Nutrients.Caffeine.rawValue) }
    
    // Minerals
    var totalCalcium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Calcium.rawValue) }
    var totalChloride : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Chloride.rawValue) }
    var totalIron : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Iron.rawValue) }
    var totalMagnesium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Magnesium.rawValue) }
    var totalPhosphorus : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Phosphorus.rawValue) }
    var totalPotassium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Potassium.rawValue) }
    var totalSodium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Sodium.rawValue) }
    var totalZinc : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Zinc.rawValue) }
    
    // Vitamins
    var totalVitaminA : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminA.rawValue) }
    var totalVitaminB1 : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminB1.rawValue) }
    var totalVitaminB12 : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminB12.rawValue) }
    var totalVitaminB2 : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminB2.rawValue) }
    var totalVitaminB3 : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminB3.rawValue) }
    var totalVitaminB5 : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminB5.rawValue) }
    var totalVitaminB6 : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminB6.rawValue) }
    var totalVitaminB7 : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminB7.rawValue) }
    var totalVitaminC : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminC.rawValue) }
    var totalVitaminD : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminD.rawValue) }
    var totalVitaminE : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminE.rawValue) }
    var totalVitaminK : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.VitaminK.rawValue) }
    var totalFolate : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Folate.rawValue) }
    
    // Ultra-Trace Minerals
    var totalChromium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Chromium.rawValue) }
    var totalCopper : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Copper.rawValue) }
    var totalIodine : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Iodine.rawValue) }
    var totalManganese : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Manganese.rawValue) }
    var totalMolybdenum : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Molybdenum.rawValue) }
    var totalSelenium : Double? { return self.nutritionTotalizer(forNutrient: Nutrients.Selenium.rawValue) }

    var energyConsumed : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Energy.rawValue) }
    
    // Macros
    var protein : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Protein.rawValue) }
    var fats : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Fat.rawValue) } 
    var carbs : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Carbs.rawValue) }
    
    // Carbs
    var sugar : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Sugar.rawValue) }
    var fiber : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Fiber.rawValue) }
    
    // Lipids
    var cholesterol : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Cholesterol.rawValue) }
    var monounsaturatedFat : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.MonounsaturatedFat.rawValue) }
    var polyunsaturatedFat : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.PolyunsaturatedFat.rawValue) }
    var saturatedFat : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.SaturatedFat.rawValue) }
    
    // Other
    var caffeine : Double? { return nutritionTotalizerForFood(forNutrient: Nutrients.Caffeine.rawValue) }
    
    // Minerals
    var calcium : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Calcium.rawValue) }
    var chloride : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Chloride.rawValue) }
    var iron : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Iron.rawValue) }
    var magnesium : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Magnesium.rawValue) }
    var phosphorus : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Phosphorus.rawValue) }
    var potassium : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Potassium.rawValue) }
    var sodium : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Sodium.rawValue) }
    var zinc : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Zinc.rawValue) }
    
    // Vitamins
    var vitaminA : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminA.rawValue) }
    var vitaminB1 : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminB1.rawValue) }
    var vitaminB12 : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminB12.rawValue) }
    var vitaminB2 : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminB2.rawValue) }
    var vitaminB3 : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminB3.rawValue) }
    var vitaminB5 : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminB5.rawValue) }
    var vitaminB6 : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminB6.rawValue) }
    var vitaminB7 : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminB7.rawValue) }
    var vitaminC : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminC.rawValue) }
    var vitaminD : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminD.rawValue) }
    var vitaminE : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminE.rawValue) }
    var vitaminK : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.VitaminK.rawValue) }
    var folate : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Folate.rawValue) }
    
    // Ultra-Trace Minerals
    var chromium : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Chromium.rawValue) }
    var copper : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Copper.rawValue) }
    var iodine : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Iodine.rawValue) }
    var manganese : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Manganese.rawValue) }
    var molybdenum : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Molybdenum.rawValue) }
    var selenium : Double? { return self.nutritionTotalizerForFood(forNutrient: Nutrients.Selenium.rawValue) }
    
    mutating func refreshLogs(logs: [NutritionLog]){
        self.logs.removeAll()
        self.logs = logs

        self.dailyTotal = self.totalEnergyConsumed
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
        self.percentComplete = self.dailyTotal! / self.target! * 100
        self.percentRemaining = 100 - self.percentRemaining!
        
        self.summaryData = [
            (Nutrients.Protein.rawValue,self.totalProtein!, "g"),
            (Nutrients.Carbs.rawValue, self.totalCarbs!, "g"),
            (Nutrients.Fat.rawValue, self.totalFats!, "g")
        ]
        
        self.macros = [
            (Nutrients.Protein.rawValue, self.totalProtein!, "g"),
            (Nutrients.Fat.rawValue,self.totalFats!, "g"),
            (Nutrients.Carbs.rawValue,self.totalCarbs!, "g")
        ]
               
       self.carbohydrates = [
           (Nutrients.Sugar.rawValue, sugar!, totalSugar!, "g"),
           (Nutrients.Fiber.rawValue, fiber!, totalFiber!, "g")
       ]
       
       self.lipids = [
           (Nutrients.Cholesterol.rawValue, cholesterol!, totalCholesterol!, "mg"),
           (Nutrients.MonounsaturatedFat.rawValue, monounsaturatedFat!, totalMonounsaturatedFat!, "g"),
           (Nutrients.PolyunsaturatedFat.rawValue, polyunsaturatedFat!, totalPolyunsaturatedFat!, "g"),
           (Nutrients.SaturatedFat.rawValue, saturatedFat!, totalSaturatedFat!, "g")
       ]

       self.minerals = [
            (Nutrients.Calcium.rawValue, calcium!, self.totalCalcium!, "mg"),
            (Nutrients.Chloride.rawValue, chloride!, self.totalChloride!, "mg"),
            (Nutrients.Magnesium.rawValue, magnesium!,self.totalMagnesium!, "mg"),
            (Nutrients.Phosphorus.rawValue, phosphorus!,self.totalPhosphorus!, "mg"),
            (Nutrients.Potassium.rawValue, potassium!, self.totalPotassium!, "mg"),
            (Nutrients.Sodium.rawValue, sodium!, self.totalSodium!, "mg")
        ]
       
       self.vitamins = [
           (Nutrients.VitaminA.rawValue, vitaminA!, totalVitaminA!, "mg"),
           (Nutrients.VitaminB1.rawValue, vitaminB1!, totalVitaminB1!, "mg"),
           (Nutrients.VitaminB12.rawValue, vitaminB12!, totalVitaminB12!, "mg"),
           (Nutrients.VitaminB2.rawValue, vitaminB2!, totalVitaminB2!, "mg"),
           (Nutrients.VitaminB3.rawValue, vitaminB3!, totalVitaminB3!, "mg"),
           (Nutrients.VitaminB5.rawValue, vitaminB5!, totalVitaminB5!, "mg"),
           (Nutrients.VitaminB6.rawValue, vitaminB6!, totalVitaminB6!, "mg"),
           (Nutrients.VitaminB7.rawValue, vitaminB7!, totalVitaminB7!, "mg"),
           (Nutrients.VitaminC.rawValue, vitaminC!, totalVitaminC!, "mg"),
           (Nutrients.VitaminD.rawValue, vitaminD!, totalVitaminD!, "mg"),
           (Nutrients.VitaminE.rawValue, vitaminE!, totalVitaminE!, "mg"),
           (Nutrients.VitaminK.rawValue, vitaminK!, totalVitaminK!, "mg"),
           (Nutrients.Folate.rawValue, folate!, totalFolate!, "mg")
       ]
       
       self.ultraTraceMinerals = [
           (Nutrients.Chromium.rawValue, chromium!, totalChromium!, "mcg"),
           (Nutrients.Copper.rawValue, copper!, totalCopper!, "mcg"),
           (Nutrients.Iodine.rawValue, iodine!, totalIodine!, "mcg"),
           (Nutrients.Manganese.rawValue, manganese!, totalManganese!, "mcg"),
           (Nutrients.Molybdenum.rawValue, molybdenum!, totalMolybdenum!, "mcg"),
           (Nutrients.Selenium.rawValue, selenium!, totalSelenium!, "mcg"),
       ]
        

        
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
        self.percentComplete = 0.0
        self.percentRemaining = 0.0
        self.summaryData = [
             (Nutrients.Protein.rawValue,self.totalProtein!, "g"),
             (Nutrients.Carbs.rawValue, self.totalCarbs!, "g"),
             (Nutrients.Fat.rawValue, self.totalFats!, "g")
         ]
         
         self.macros = [
             (Nutrients.Protein.rawValue, self.totalProtein!, "g"),
             (Nutrients.Fat.rawValue,self.totalFats!, "g"),
             (Nutrients.Carbs.rawValue,self.totalCarbs!, "g")
         ]
                
        self.carbohydrates = [
            (Nutrients.Sugar.rawValue, sugar!, totalSugar!, "g"),
            (Nutrients.Fiber.rawValue, fiber!, totalFiber!, "g")
        ]
        
        self.lipids = [
            (Nutrients.Cholesterol.rawValue, cholesterol!, totalCholesterol!, "mg"),
            (Nutrients.MonounsaturatedFat.rawValue, monounsaturatedFat!, totalMonounsaturatedFat!, "g"),
            (Nutrients.PolyunsaturatedFat.rawValue, polyunsaturatedFat!, totalPolyunsaturatedFat!, "g"),
            (Nutrients.SaturatedFat.rawValue, saturatedFat!, totalSaturatedFat!, "g")
        ]

        self.minerals = [
             (Nutrients.Calcium.rawValue, calcium!, self.totalCalcium!, "mg"),
             (Nutrients.Chloride.rawValue, chloride!, self.totalChloride!, "mg"),
             (Nutrients.Magnesium.rawValue, magnesium!,self.totalMagnesium!, "mg"),
             (Nutrients.Phosphorus.rawValue, phosphorus!,self.totalPhosphorus!, "mg"),
             (Nutrients.Potassium.rawValue, potassium!, self.totalPotassium!, "mg"),
             (Nutrients.Sodium.rawValue, sodium!, self.totalSodium!, "mg")
         ]
        
        self.vitamins = [
            (Nutrients.VitaminA.rawValue, vitaminA!, totalVitaminA!, "mg"),
            (Nutrients.VitaminB1.rawValue, vitaminB1!, totalVitaminB1!, "mg"),
            (Nutrients.VitaminB12.rawValue, vitaminB12!, totalVitaminB12!, "mg"),
            (Nutrients.VitaminB2.rawValue, vitaminB2!, totalVitaminB2!, "mg"),
            (Nutrients.VitaminB3.rawValue, vitaminB3!, totalVitaminB3!, "mg"),
            (Nutrients.VitaminB5.rawValue, vitaminB5!, totalVitaminB5!, "mg"),
            (Nutrients.VitaminB6.rawValue, vitaminB6!, totalVitaminB6!, "mg"),
            (Nutrients.VitaminB7.rawValue, vitaminB7!, totalVitaminB7!, "mg"),
            (Nutrients.VitaminC.rawValue, vitaminC!, totalVitaminC!, "mg"),
            (Nutrients.VitaminD.rawValue, vitaminD!, totalVitaminD!, "mg"),
            (Nutrients.VitaminE.rawValue, vitaminE!, totalVitaminE!, "mg"),
            (Nutrients.VitaminK.rawValue, vitaminK!, totalVitaminK!, "mg"),
            (Nutrients.Folate.rawValue, folate!, totalFolate!, "mg")
        ]
        
        self.ultraTraceMinerals = [
            (Nutrients.Chromium.rawValue, chromium!, totalChromium!, "mcg"),
            (Nutrients.Copper.rawValue, copper!, totalCopper!, "mcg"),
            (Nutrients.Iodine.rawValue, iodine!, totalIodine!, "mcg"),
            (Nutrients.Manganese.rawValue, manganese!, totalManganese!, "mcg"),
            (Nutrients.Molybdenum.rawValue, molybdenum!, totalMolybdenum!, "mcg"),
            (Nutrients.Selenium.rawValue, selenium!, totalSelenium!, "mcg"),
        ]
        
        
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
    
    private func nutritionTotalizerForFood(forNutrient nutrient: String) -> Double{
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

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
    var logs : [NutritionLog]? {
        didSet {
            refreshActivity()
        }
    }
    var nutritionLogs : [NutritionLog]?
    
    // MARK: Calculator
    var calculator : NutritionCalculator?
    var totalNutrition : [String : Double]?     // total nutrition (food + drinks)
    var nutrition : [String : Double]?      // nutrition filtered for food only.
    
    // MARK: Nutrition Groups
    var macros : [(String, Double, String)]?
    var lipids : [(String, Double, String)]?
    var carbohydrates : [(String, Double, String)]?
    var vitamins : [(String, Double, String)]?
    var minerals : [(String, Double, String)]?
    var ultraTraceMinerals : [(String, Double, String)]?
    
    // calculated propeties
    var rollingTotal : [Double]?
    
    
    init(){
        name = "Nutrition"
        icon = UIImage.Theme.Activity.eat
        color = UIColor.Theme.Activity.eat
        unit = "Calories"
        target = 0.0
        dailyTotal = 0.0
        remainingToTarget = 0.0
        percentComplete = 0.0
        percentRemaining = 0.0

        calculator = NutritionCalculator()
        summaryData = []
        macros = []
        carbohydrates = []
        lipids = []
        minerals = []
        vitamins = []
        ultraTraceMinerals = []
        
        rollingTotal = []
        nutritionLogs = []
    }

    private mutating func refreshActivity(){
        
        // filter the logs beforehand so that they can be used for the calculations.
        nutritionLogs = calculator!.filterLogs(closure: calculator!.food, logs: logs!)
        
        totalNutrition = calculator!.totalizeNutrition(logs: logs!)
        nutrition = calculator!.totalizeNutrition(logs: nutritionLogs!)
        rollingTotal = calculator!.calculateHydrationRunningTotal(logs: logs!)
        
        dailyTotal = totalNutrition![Nutrients.Energy.rawValue] ?? 0.0
        remainingToTarget = (target! - dailyTotal!) < 0.0 ? 0.0 : (target! - dailyTotal!)
        percentComplete = (target! > 0) ? (dailyTotal! / target!) * 100 : 0.0
        percentRemaining = (100 - percentComplete!) > 0 ? (100 - percentComplete!) : 0.0
        
        summaryData = [
            (Nutrients.Protein.rawValue, totalNutrition![Nutrients.Protein.rawValue] ?? 0.0, "g"),
            (Nutrients.Carbs.rawValue, totalNutrition![Nutrients.Carbs.rawValue] ?? 0.0, "g"),
            (Nutrients.Fat.rawValue, totalNutrition![Nutrients.Fat.rawValue] ?? 0.0, "g"),
        ]
        
        macros = [
            (Nutrients.Protein.rawValue,totalNutrition![Nutrients.Protein.rawValue] ?? 0.0, "g"),
            (Nutrients.Carbs.rawValue,totalNutrition![Nutrients.Carbs.rawValue] ?? 0.0, "g"),
            (Nutrients.Fat.rawValue,totalNutrition![Nutrients.Fat.rawValue] ?? 0.0, "g"),
        ]
                
        carbohydrates = [
            (Nutrients.Sugar.rawValue, totalNutrition![Nutrients.Sugar.rawValue] ?? 0.0, "g"),
            (Nutrients.Fiber.rawValue, totalNutrition![Nutrients.Fiber.rawValue] ?? 0.0, "g")
        ]
            
        lipids = [
            (Nutrients.Cholesterol.rawValue, totalNutrition![Nutrients.Cholesterol.rawValue] ?? 0.0, "mg"),
            (Nutrients.MonounsaturatedFat.rawValue, totalNutrition![Nutrients.MonounsaturatedFat.rawValue] ?? 0.0, "g"),
            (Nutrients.PolyunsaturatedFat.rawValue, totalNutrition![Nutrients.PolyunsaturatedFat.rawValue] ?? 0.0, "g"),
            (Nutrients.SaturatedFat.rawValue, totalNutrition![Nutrients.SaturatedFat.rawValue] ?? 0.0, "g")
        ]
        
        minerals = [
            (Nutrients.Calcium.rawValue,totalNutrition![Nutrients.Calcium.rawValue] ?? 0.0, "mg"),
            (Nutrients.Chloride.rawValue,totalNutrition![Nutrients.Chloride.rawValue] ?? 0.0, "mg"),
            (Nutrients.Magnesium.rawValue,totalNutrition![Nutrients.Magnesium.rawValue] ?? 0.0, "mg"),
            (Nutrients.Phosphorus.rawValue,totalNutrition![Nutrients.Phosphorus.rawValue] ?? 0.0, "mg"),
            (Nutrients.Potassium.rawValue,totalNutrition![Nutrients.Potassium.rawValue] ?? 0.0, "mg"),
            (Nutrients.Sodium.rawValue,totalNutrition![Nutrients.Sodium.rawValue] ?? 0.0, "mg")
        ]
            
        vitamins = [
            (Nutrients.VitaminA.rawValue,totalNutrition![Nutrients.VitaminA.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminB1.rawValue,totalNutrition![Nutrients.VitaminB1.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminB12.rawValue,totalNutrition![Nutrients.VitaminB12.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminB2.rawValue,totalNutrition![Nutrients.VitaminB2.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminB3.rawValue,totalNutrition![Nutrients.VitaminB3.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminB5.rawValue,totalNutrition![Nutrients.VitaminB5.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminB6.rawValue,totalNutrition![Nutrients.VitaminB6.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminB7.rawValue,totalNutrition![Nutrients.VitaminB7.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminC.rawValue,totalNutrition![Nutrients.VitaminC.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminD.rawValue,totalNutrition![Nutrients.VitaminD.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminE.rawValue,totalNutrition![Nutrients.VitaminE.rawValue] ?? 0.0, "mg"),
            (Nutrients.VitaminK.rawValue,totalNutrition![Nutrients.VitaminK.rawValue] ?? 0.0, "mg"),
            (Nutrients.Folate.rawValue,totalNutrition![Nutrients.Folate.rawValue] ?? 0.0, "mg")
        ]
            
        ultraTraceMinerals = [
            (Nutrients.Chromium.rawValue,totalNutrition![Nutrients.Chromium.rawValue] ?? 0.0, "mcg"),
            (Nutrients.Copper.rawValue,totalNutrition![Nutrients.Copper.rawValue] ?? 0.0, "mcg"),
            (Nutrients.Iodine.rawValue,totalNutrition![Nutrients.Iodine.rawValue] ?? 0.0, "mcg"),
            (Nutrients.Manganese.rawValue,totalNutrition![Nutrients.Manganese.rawValue] ?? 0.0, "mcg"),
            (Nutrients.Molybdenum.rawValue,totalNutrition![Nutrients.Molybdenum.rawValue] ?? 0.0, "mcg"),
            (Nutrients.Selenium.rawValue,totalNutrition![Nutrients.Selenium.rawValue] ?? 0.0, "mcg")
        ]
        
        
    }
}


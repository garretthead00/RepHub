//
//  NutritionLog.swift
//  RepHub
//
//  Created by Garrett Head on 1/29/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import Foundation

class NutritionLog {

    
    var id : String?
    var foodId: String?
    var timestamp: Double?
    var servingSize : Double?
    var servingSizeUnit : String?
    var householdServingSize : Double?
    var householdServingSizeUnit : String?
    var food : FoodItem?
    var nutrition : [Nutrient]?

    
}

extension NutritionLog {
    
    
    static func transformNutritionLog(data: [String: Any], key: String) -> NutritionLog {
        let log = NutritionLog()
        log.id = key
        log.foodId = data["foodId"] as? String
        log.servingSize = data["servingSize"] as? Double
        log.servingSizeUnit = data["servingSizeUOM"] as? String
        log.householdServingSize = data["householdServingSize"] as? Double
        log.householdServingSizeUnit = data["householdServingSizeUOM"] as? String
        log.timestamp = data["timestamp"] as? Double
        log.nutrition = [] as? [Nutrient]
        return log
    }

}

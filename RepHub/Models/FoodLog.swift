//
//  FoodLog.swift
//  RepHub
//
//  Created by Garrett Head on 11/28/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class FoodLog {
    
    var id : String?
    var timestamp : Double?
    var servingSize : Double?
    var servingSizeUnit : String?
    var householdServingSize : Double?
    var householdServingSizeUnit : String?
    var foodId : Int?
    var drinkName : String?
    var drinkType : String?

}


extension FoodLog {
    
    static func transformFoodLog(data: [String: Any], key: String) -> FoodLog {
        let log = FoodLog()
        log.id = key
        log.foodId = data["foodId"] as? Int
        log.timestamp = data["timestamp"] as? Double
        log.servingSize = data["servingSize"] as? Double
        log.servingSizeUnit = data["servingSizeUOM"] as? String
        log.householdServingSize = data["householdServingSize"] as? Double
        log.householdServingSizeUnit = data["householdServingSizeUOM"] as? String
        return log
    }
}

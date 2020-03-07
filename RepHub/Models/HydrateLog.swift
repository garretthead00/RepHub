//
//  HydrateLog.swift
//  RepHub
//
//  Created by Garrett Head on 7/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class HydrateLog {

    
    var id : String?
    var drinkId: String?
    var timestamp: Double?
    var servingSize : Double?
    var servingSizeUnit : String?
    var householdServingSize : Double?
    var householdServingSizeUnit : String?
    var drink : FoodItem?
    var nutrition : [Nutrient]?

    
}

extension HydrateLog {
    
    
    static func transformHydrateLog(data: [String: Any], key: String) -> HydrateLog {
        let log = HydrateLog()
        log.id = key
        log.drinkId = data["foodId"] as? String
        log.servingSize = data["servingSize"] as? Double
        log.servingSizeUnit = data["servingSizeUOM"] as? String
        log.householdServingSize = data["householdServingSize"] as? Double
        log.householdServingSizeUnit = data["householdServingSizeUOM"] as? String
        log.timestamp = data["timestamp"] as? Double
        log.nutrition = [] as? [Nutrient]
        
        
        return log
    }

}

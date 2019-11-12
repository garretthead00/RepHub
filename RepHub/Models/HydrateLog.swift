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
    var servingSize : Double?
    var servingSizeUnit : String?
    var householdServingSize : Double?
    var householdServingSizeUnit : String?
    var timeStamp : Double?
    var drinkId : Int?
    var drinkName : String?
    var drinkType : String?
}

extension HydrateLog {
    
    static func transformHydrateLog(data: [String: Any], key: String) -> HydrateLog {
        let log = HydrateLog()
        log.id = key
        log.servingSize = data["servingSize"] as? Double
        log.drinkId = data["drinkId"] as? Int
        log.servingSizeUnit = data["servingSizeUOM"] as? String
        log.householdServingSize = data["householdServingSize"] as? Double
        log.householdServingSizeUnit = data["householdServingSizeUOM"] as? String
        log.timeStamp = data["timestamp"] as? Double
        log.drinkName = data["name"] as? String
        log.drinkType = data["type"] as? String
        return log
    }
}

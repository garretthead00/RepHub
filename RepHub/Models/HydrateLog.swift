//
//  HydrateLog.swift
//  RepHub
//
//  Created by Garrett Head on 7/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class HydrateLog : ActivityLog {

    
    var timestamp: Double
    var unit: String
    var value: Double
    

    var id : String?
    var servingSize : Double?
    var servingSizeUnit : String?
    var householdServingSize : Double?
    var householdServingSizeUnit : String?
    //var timeStamp : Double?
    var drinkId : Int?
    var drinkName : String?
    var drinkType : String?
    
    init(){
        self.timestamp = 0.0
        self.value = 0.0
        self.unit = ""
    }
    
    init(timestamp: Double, value: Double, unit: String) {
        self.timestamp = timestamp
        self.value = value
        self.unit = unit
    }
    
}

extension HydrateLog {
    
    

    
    static func transformHydrateLog(data: [String: Any], key: String) -> HydrateLog {
        
        let timestamp = data["timestamp"] as! Double
        let servingSize = data["servingSize"] as! Double
        let unit = data["servingSizeUOM"] as! String
            
        
        
        let log = HydrateLog(timestamp: timestamp, value: servingSize, unit: unit)
        log.id = key
        log.servingSize = data["servingSize"] as? Double
        log.drinkId = data["drinkId"] as? Int
        log.servingSizeUnit = data["servingSizeUOM"] as? String
        log.householdServingSize = data["householdServingSize"] as? Double
        log.householdServingSizeUnit = data["householdServingSizeUOM"] as? String
        log.drinkName = data["name"] as? String
        log.drinkType = data["type"] as? String
        return log
    }
    
//    static func transformHydrateLog(data: [String: Any], key: String) -> HydrateLog {
//        let log = HydrateLog()
//        log.id = key
//        log.servingSize = data["servingSize"] as? Double
//        log.drinkId = data["drinkId"] as? Int
//        log.servingSizeUnit = data["servingSizeUOM"] as? String
//        log.householdServingSize = data["householdServingSize"] as? Double
//        log.householdServingSizeUnit = data["householdServingSizeUOM"] as? String
//        log.timeStamp = data["timestamp"] as? Double
//        log.drinkName = data["name"] as? String
//        log.drinkType = data["type"] as? String
//        return log
//    }
}

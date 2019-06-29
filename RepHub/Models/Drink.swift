//
//  Drink.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class Drink {
    
    var name : String?
    var ndb_no : Int?
    var manufacturer : String?
    var dateAvailable : String?
    var servingSize : Double?
    var servingSizeUnit : String?
    var householdServingSize : Double?
    var householdServingSizeUnit : String?
    var type : String?
    
}

extension Drink {
    
    static func transformDrink(data: [String: Any], key: String) -> Drink {
        let drink = Drink()
        drink.name = data["Name"] as? String
        drink.ndb_no = data["ID"] as? Int
        drink.dateAvailable = data["mostRecentDateAvailable"] as? String
        drink.servingSize = data["servingSize"] as? Double
        drink.servingSizeUnit = data["servingSizeUOM"] as? String
        drink.householdServingSize = data["householdServingSize"] as? Double
        drink.householdServingSizeUnit = data["householdServingSizeUOM"] as? String
        drink.manufacturer = data["manufacturer"] as? String
        drink.type = data["Category"] as? String
        return drink
    }
    
    
}

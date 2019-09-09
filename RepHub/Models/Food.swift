//
//  Food.swift
//  RepHub
//
//  Created by Garrett Head on 9/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class Food {

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

extension Food {
    static func transformFoodByType(data: [String: Any], key: String) -> Food {
        let food = Food()
        food.name = data["Name"] as? String
        food.ndb_no = data["ID"] as? Int
        food.manufacturer = data["Manufacturer"] as? String
        food.type = data["Sub Category 1"] as? String
        return food
    }
}

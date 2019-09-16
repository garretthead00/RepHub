//
//  Nutrient.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class Nutrient {
    
    var name : String?
    var ndb_no : String?
    var unit : String?
    var value : Double?
    
}

extension Nutrient {
    
    static func transformNutrient(data: [String: Any], key: String) -> Nutrient {
        let nutrient = Nutrient()
        nutrient.ndb_no = key
        nutrient.name = data["name"] as? String
        nutrient.unit = data["unit"] as? String
        nutrient.value = data["value"] as? Double
        return nutrient
    }
    
    
}

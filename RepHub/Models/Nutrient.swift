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
    var id : String?
    var unit : String?
    var value : Double?
    var category : String?
    var secondaryName : String?
    
}

extension Nutrient {
    
    static func transformNutrient(data: [String: Any], key: String) -> Nutrient {
        let nutrient = Nutrient()
        nutrient.id = key
        nutrient.name = data["Nutrient"] as? String
        nutrient.unit = data["Unit"] as? String
        nutrient.value = data["Value"] as? Double
        nutrient.category = data["Category"] as? String
        nutrient.secondaryName = data["Secondary Name"] as? String
        return nutrient
    }
    
    
}

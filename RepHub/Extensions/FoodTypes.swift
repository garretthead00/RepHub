//
//  FoodTypes.swift
//  RepHub
//
//  Created by Garrett Head on 9/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

enum FruitTypes : String {
    case Berries = "Berries"
    case Citrus = "Citrus"
    case Drupes = "Drupes"
    case Melons = "Melons"
    case Tropical = "Tropical"
    case Pomes = "Pomes"
    
}

struct FoodTypesByGroup {

    func foodTypes(byGroup: String) -> [String] {
        switch byGroup {
        case "Fruit" : return ["Berries", "Citrus", "Tropical", "Drupes", "Melons", "Pomes"]
        default : return []
        }
    }
}


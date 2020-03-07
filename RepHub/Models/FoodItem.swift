//
//  Food.swift
//  RepHub
//
//  Created by Garrett Head on 9/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class FoodItem {
    
    var name : String?
    var id : String?
    var foodGroup : String?
    var servingSize : Double?
    var servingSizeUnit : String?
    var householdServingSize : Double?
    var householdServingSizeUnit : String?
    var category : String?
    var subCategory : String?
    var subCategory2 : String?
    var source : String?
    var sourceDescription : String?
    
}

extension FoodItem {
    
    static func transformFood(data: [String: Any], key: String) -> FoodItem {
        let food = FoodItem()
        food.id = key
        food.name = data["name"] as? String
        food.foodGroup = data["foodGroup"] as? String
        food.servingSize = data["servingSize"] as? Double
        food.servingSizeUnit = data["servingSizeUnit"] as? String
        food.householdServingSize = data["householdServingSize"] as? Double
        food.householdServingSizeUnit = data["householdServingSizeUnit"] as? String
        food.category = data["category"] as? String
        food.subCategory = data["subCategory1"] as? String
        food.subCategory2 = data["subCategory2"] as? String
        food.source = data["source"] as? String
        food.sourceDescription = data["sourceDescription"] as? String
        return food
    }
    
    func foodTypes(byGroup: String) -> [String] {
        switch byGroup {
        case "Fruit" : return ["Berries", "Citrus", "Tropical", "Drupes", "Melons", "Pomes"]
        case "Vegetables" : return ["Flower","Fruit","Gourds And Squashes","Leafy Greens","Legumes","Bulb And Stem","Podded","Root And Tuberous"]
        case "Fats" : return ["Butter","Dressing","Oil","Shortening"]
        case "Dairy" : return ["Cheese", "Cream", "Milk", "Sherbert", "Yogurt"]
        case "Protein" : return ["Meat","Eggs","Poultry","Fish","Crustaceans","Mollusks","Beans","Nuts","Seeds","Veggie","Meatless"]
        default : return []
        }
    }
    
}

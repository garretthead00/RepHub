//
//  FoodTypes.swift
//  RepHub
//
//  Created by Garrett Head on 9/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


struct Food {

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



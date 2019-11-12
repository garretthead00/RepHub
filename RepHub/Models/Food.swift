//
//  FoodTypes.swift
//  RepHub
//
//  Created by Garrett Head on 9/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


protocol Food {
    var name : String { get }
    var nutritionId : String { get }
    var description : String { get }
    var category : String { get }
    var subCategory : String { get }
    var ingredients : [Food] { get }
    

    
    
}

//extension Food {
//    
//    init(name: String, nutritionId: String, desc: String, category: String, subCategory: String, indegredients: [Food]){
//        self.name = name
//        self.nutritionId = nutritionId
//        self.description = desc
//        self.category = category
//        self.subCategory = ""
//        self.ingredients = []
//        
//    }
//
//    
//}


//struct Food {
//
//    func foodTypes(byGroup: String) -> [String] {
//        switch byGroup {
//        case "Fruit" : return ["Berries", "Citrus", "Tropical", "Drupes", "Melons", "Pomes"]
//        case "Vegetables" : return ["Flower","Fruit","Gourds And Squashes","Leafy Greens","Legumes","Bulb And Stem","Podded","Root And Tuberous"]
//        case "Fats" : return ["Butter","Dressing","Oil","Shortening"]
//        case "Dairy" : return ["Cheese", "Cream", "Milk", "Sherbert", "Yogurt"]
//        case "Protein" : return ["Meat","Eggs","Poultry","Fish","Crustaceans","Mollusks","Beans","Nuts","Seeds","Veggie","Meatless"]
//        default : return []
//        }
//    }
//}



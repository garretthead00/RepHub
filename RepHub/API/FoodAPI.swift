//
//  Food.swift
//  RepHub
//
//  Created by Garrett Head on 9/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FoodAPI {
    
    var FOOD_DB_REF = Database.database().reference().child("food")
    func observeFood(ofGroup group: String, completion: @escaping(FoodItem) -> Void){
        FOOD_DB_REF.queryOrdered(byChild: "foodGroup").queryEqual(toValue: group).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any] {
                let food = FoodItem.transformFood(data: data, key: snapshot.key)
                completion(food)
            }
        })
    }
    
    
    
    /// MARK!!! need to create a unique drink query
    func observeFood(byType foodType:String, completion: @escaping(FoodItem) -> Void){
        
        FOOD_DB_REF.child("Drinks").observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any] {
                let drink = FoodItem.transformFood(data: data, key: snapshot.key)
                completion(drink)
            }
        })
        
        

    }
//    var query = ref.orderByChild("database/username").equalTo("some_data");
//    query.once("value", function(snapshot) {
    
    
}

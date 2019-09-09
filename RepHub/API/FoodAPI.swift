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
    
    var FOOD_BY_TYPE_DB_REF = Database.database().reference().child("food")
    func observeFood(ofGroup group: String, byType foodType:String, completion: @escaping(Food) -> Void){
        FOOD_BY_TYPE_DB_REF.child(group.lowercased()).child(foodType).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any] {
                let food = Food.transformFoodByType(data: data, key: snapshot.key)
                completion(food)
            }
        })
    }
}

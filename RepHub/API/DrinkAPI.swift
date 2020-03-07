//
//  DrinkAPI.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


class DrinkAPI {

    var DRINKS_BY_TYPE_DB_REF = Database.database().reference().child("foodByGroup").child("Drinks")
    func observeDrinks(byType drinkType:String, completion: @escaping(FoodItem) -> Void){
        let query = DRINKS_BY_TYPE_DB_REF.queryOrdered(byChild: "Category").queryEqual(toValue: drinkType)
        query.observe(.value, with: {
            snapshot in
            for childSnapshot in snapshot.children {
                if let child = childSnapshot as? DataSnapshot {
                    if let data = child.value as? [String:Any] {
                        let drink = FoodItem.transformFood(data: data, key: snapshot.key)
                        completion(drink)
                    }
                }
            }
        })
    }
    
    var DRINKS_DB_REF = Database.database().reference().child("drinks")
    func observeDrink(withId id: String, completion:  @escaping(Drink) -> Void){
        DRINKS_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any] {
                let drink = Drink.transformDrink(data: data, key: snapshot.key)
                completion(drink)
            }
        })
    }
}

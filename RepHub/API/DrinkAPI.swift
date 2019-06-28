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

    var DRINKS_BY_TYPE_DB_REF = Database.database().reference().child("drinksByType")
    func observerDrinks(drinkType:String, completion: @escaping(Drink) -> Void){
        DRINKS_BY_TYPE_DB_REF.child(drinkType).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any] {
                let drink = Drink.transformDrink(data: data, key: snapshot.key)
                completion(drink)
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

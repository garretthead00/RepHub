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

    var DRINK_DB_REF = Database.database().reference().child("drinks")

    
    func observerDrinks(drinkType:String, completion: @escaping(Drink) -> Void){
        DRINK_DB_REF.child(drinkType).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any] {
                let drink = Drink.transformDrink(data: data, key: snapshot.key)
                completion(drink)
            }
        })
        
    }
    

}

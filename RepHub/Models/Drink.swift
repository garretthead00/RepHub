//
//  Drink.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class Drink {
    
    var name : String?
    var ndb_no : Int?
    var manufacturer : String?
    var dateAvailable : String?
    
}

extension Drink {
    
    static func transformDrink(data: [String: Any], key: String) -> Drink {
        let drink = Drink()
        drink.name = data["Firebase Name"] as? String
        drink.ndb_no = data["ID"] as? Int
        drink.dateAvailable = data["mostRecent_DateAvailable"] as? String
        drink.manufacturer = ""
        return drink
    }
    
    
}

//
//  Nutrient.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class NutrientAPI {

    var NUTRITION_DB_REF = Database.database().reference().child("nutrition")
    
    func observeNutrition(withId id: String, completion: @escaping(Nutrient) -> Void){
        NUTRITION_DB_REF.child(id).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any]{
                let nutrient = Nutrient.transformNutrient(data: data, key: id)
                completion(nutrient)
            }
        })
    }
    
    
}


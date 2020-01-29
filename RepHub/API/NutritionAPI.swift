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

class NutritionAPI {

    var NUTRITION_DB_REF = Database.database().reference().child("nutrition")
    var USER_NUTRITION_LOGS_DB_REF = Database.database().reference().child("user-nutrition-logs")
    
    func observeNutrition(withId id: String, completion: @escaping(Nutrient) -> Void){
        NUTRITION_DB_REF.child(id).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any]{
                let nutrient = Nutrient.transformNutrient(data: data, key: id)
                completion(nutrient)
            }
        })

    }
    
    func saveNutritionLog(forUserId id: String, logId: String, nutrients: [Nutrient], completion: @escaping(String) -> Void){
        let userNutritionLogRef = USER_NUTRITION_LOGS_DB_REF.child(id).child(logId)
        for (index, element) in nutrients.enumerated() {
            if let nutrient = element.name, let value = element.value, let unit = element.unit {
                let key = String(index)
                let ref = userNutritionLogRef.child(key)
                ref.setValue(["Nutrient": nutrient, "Value": value, "Unit": unit], withCompletionBlock: {
                    error, ref in
                    if error != nil {
                        ProgressHUD.showError(error!.localizedDescription)
                        return
                    }
                    
                })
            }
        }
        completion(logId)
        
    }
    
    func observeNutritionLog(forUserId userId: String, logId: String, completion: @escaping(Nutrient) -> Void){
        print("query nutrition Logs")
        USER_NUTRITION_LOGS_DB_REF.child(userId).child(logId).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any]{
                print("nutrition snapshot successfull")
                let nutrient = Nutrient.transformNutrient(data: data, key: snapshot.key)
                completion(nutrient)
            }
        })
    }
    
    func dispatchNutritionLog(forUserId userId: String, logId: String, completion: @escaping([Nutrient]) -> Void){
        print("dispatchNutrition")
        var nutrition = [Nutrient]()
        let myGroup = DispatchGroup()
        myGroup.enter()

        USER_NUTRITION_LOGS_DB_REF.child(userId).child(logId).observe(.childAdded, with: {
            snapshot in
            print("got nutrition snapshot")
            let items = snapshot.children.allObjects as! [DataSnapshot]
            for (_, item) in items.enumerated() {

                if let data = item.value as? [String:Any]{
                    print("dispatchGroup iteration")
                    let nutrient = Nutrient.transformNutrient(data: data, key: item.key)
                    nutrition.append(nutrient)
                }

            }
            myGroup.leave()

        })
        

        
        myGroup.notify(queue: .main, execute: {
            completion(nutrition)
        })
    }
    
    
}


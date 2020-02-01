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
    
    func dispatchNutritionLog(completion: @escaping(NutritionLog) -> Void){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
           return
        }
        let currentUserId = currentUser.uid
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayAtMidnight = cal.startOfDay(for: date).timeIntervalSince1970
        print("query hydration logs")
        USER_NUTRITION_LOGS_DB_REF.child(currentUserId).queryOrdered(byChild: "timestamp").queryStarting(atValue: todayAtMidnight).observe(.childAdded, with: {
           snapshot in

            if let data = snapshot.value as? [String: Any] {
                print("hydrateLog snapshot successfull")
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                let nutrition = snapshot.childSnapshot(forPath: "nutrition").children.allObjects as! [DataSnapshot]
                //let log = HydrateLog.transformHydrateLog(data: data, key: snapshot.key)
                let log = NutritionLog.transformNutritionLog(data: data, key: snapshot.key)
                for(_, item) in nutrition.enumerated() {
                    if let data = item.value as? [String:Any]{
                        let nutrient = Nutrient.transformNutrient(data: data, key: item.key)
                        log.nutrition?.append(nutrient)
                    }
                }

                API.Food.observeDrink(withId: log.foodId!, completion: {
                    drink in
                    log.food = drink
                    dispatchGroup.leave()
                })
                dispatchGroup.notify(queue: .main, execute: {
                    completion(log)
                })
            }
        })
    }
    
    
    func saveNutritionLog(food: FoodItem, nutrients: [Nutrient], completion: @escaping(Bool) -> Void){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
           return
        }
        let currentUserId = currentUser.uid
        let newLogRef = USER_NUTRITION_LOGS_DB_REF.child(currentUserId).childByAutoId()
        let timestamp = NSDate().timeIntervalSince1970
        
        if let foodId = food.id, let servingSize = food.servingSize, let servingSizeUnit = food.servingSizeUnit, let householdServingSize = food.householdServingSize, let householdServingSizeUnit = food.householdServingSizeUnit {
            
            var nutrition = [[String:Any]]()
            for (index, element) in nutrients.enumerated() {
                if let nutrient = element.name, let value = element.value, let unit = element.unit {
                    nutrition.append(["Nutrient": nutrient, "Value": value, "Unit": unit])
                }
            }
            

            newLogRef.setValue(["timestamp": timestamp, "foodId": foodId, "servingSize": servingSize, "servingSizeUOM": servingSizeUnit, "householdServingSize": householdServingSize, "householdServingSizeUOM" : householdServingSizeUnit, "nutrition": nutrition], withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    completion(false)
                    return
                }
//                for (index, element) in nutrients.enumerated() {
//                    if let nutrient = element.name, let value = element.value, let unit = element.unit {
//                        let key = String(index)
//                        newLogRef.child("nutrition").child(key).setValue(["Nutrient": nutrient, "Value": value, "Unit": unit], withCompletionBlock: {
//                            error, ref in
//                            if error != nil {
//                                ProgressHUD.showError(error!.localizedDescription)
//                                completion(false)
//                                return
//                            }
//
//                        })
//                    }
//                }
                completion(true)
            })
        }
        
        
        
        
        
//        let userNutritionLogRef = USER_NUTRITION_LOGS_DB_REF.child(id).child(logId)
//        for (index, element) in nutrients.enumerated() {
//            if let nutrient = element.name, let value = element.value, let unit = element.unit {
//                let key = String(index)
//                let ref = userNutritionLogRef.child(key)
//                ref.setValue(["Nutrient": nutrient, "Value": value, "Unit": unit], withCompletionBlock: {
//                    error, ref in
//                    if error != nil {
//                        ProgressHUD.showError(error!.localizedDescription)
//                        return
//                    }
//
//                })
//            }
//        }
//        completion(logId)
        
        
        
    }
    
    
    
    
    
}


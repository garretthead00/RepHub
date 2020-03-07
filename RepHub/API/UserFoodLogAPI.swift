//
//  UserFoodLogAPI.swift
//  RepHub
//
//  Created by Garrett Head on 11/28/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserFoodLogAPI {
    
    var USER_FOOD_LOGS_DB_REF = Database.database().reference().child("user-food-logs")
    var USER_NUTRITION_LOGS_DB_REF = Database.database().reference().child("user-nutrition-logs")
    
    
    func observeFoodLogs(withId id: String, completion: @escaping(FoodLog) -> Void){
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayAtMidnight = cal.startOfDay(for: date).timeIntervalSince1970
        USER_FOOD_LOGS_DB_REF.child(id).queryOrdered(byChild: "timestamp").queryStarting(atValue: todayAtMidnight).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let log = FoodLog.transformFoodLog(data: data, key: snapshot.key)
                completion(log)
            }
        })
    }
    
    
    func observeHydrateLog(forUserId userId: String, logId: String, completion: @escaping(FoodLog) -> Void) {
        USER_FOOD_LOGS_DB_REF.child(userId).child(logId).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let log = FoodLog.transformFoodLog(data: data, key: snapshot.key)
                completion(log)
            }
        })
    }
    
    func removeHydrationLog(withLogId id: String, onSuccess: @escaping() -> Void) {
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        USER_FOOD_LOGS_DB_REF.child(currentUserId).child(id).removeValue(completionBlock: {
            err, ref in
            if err != nil {
                ProgressHUD.showError("Could not remove log!")
                return
            }
            onSuccess()
        })
    }
    
    func saveFoodLog(withUserId id: String, food: FoodItem, completion: @escaping(String) -> Void){
        let logRef = USER_FOOD_LOGS_DB_REF.child(id).childByAutoId()
        let timestamp = NSDate().timeIntervalSince1970
        if let foodID = food.id, let servingSize = food.servingSize, let servingSizeUnit = food.servingSizeUnit, let householdServingSize = food.householdServingSize, let householdServingSizeUnit = food.householdServingSizeUnit {
            logRef.setValue(["timestamp": timestamp, "foodId": foodID, "servingSize": servingSize, "servingSizeUOM": servingSizeUnit, "householdServingSize": householdServingSize, "householdServingSizeUOM" : householdServingSizeUnit], withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                if let key = ref.key {
                    completion(key)
                }
            })
        }
    }
    
    
}

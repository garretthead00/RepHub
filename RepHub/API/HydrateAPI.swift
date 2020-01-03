//
//  HydrateAPI.swift
//  RepHub
//
//  Created by Garrett Head on 7/22/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HydrateAPI {
    
    var HYDRATE_DB_REF = Database.database().reference().child("hydrate")
    
    /* HYDRATION LOGS */
    var HYDRATE_LOGS_DB_REF = Database.database().reference().child("user-food-logs")
    var USER_HYDRATE_LOGS_DB_REF = Database.database().reference().child("user-hydrate-logs")
    var USER_NUTRITION_LOGS_DB_REF = Database.database().reference().child("user-nutrition-logs")
    
    func observeHydrateLogs(withId id: String, completion: @escaping(HydrateLog) -> Void){
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayAtMidnight = cal.startOfDay(for: date).timeIntervalSince1970
        USER_HYDRATE_LOGS_DB_REF.child(id).queryOrdered(byChild: "timestamp").queryStarting(atValue: todayAtMidnight).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let log = HydrateLog.transformHydrateLog(data: data, key: snapshot.key)
                completion(log)
            }
        })
    }
    
    
    func observeHydrateLog(forUserId userId: String, logId: String, completion: @escaping(HydrateLog) -> Void) {
        USER_HYDRATE_LOGS_DB_REF.child(userId).child(logId).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let log = HydrateLog.transformHydrateLog(data: data, key: snapshot.key)
                completion(log)
            }
        })
    }
    
    func removeHydrationLog(withLogId id: String, onSuccess: @escaping() -> Void) {
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        HYDRATE_LOGS_DB_REF.child(currentUserId).child(id).removeValue(completionBlock: {
            err, ref in
            if err != nil {
                ProgressHUD.showError("Could not remove log!")
                return
            }
            onSuccess()
        })
    }
    
    
    func saveHyrdationLog(withUserId id: String, drink: FoodItem, completion: @escaping(String) -> Void){
        let logRef = USER_HYDRATE_LOGS_DB_REF.child(id).childByAutoId()
        let timestamp = NSDate().timeIntervalSince1970
        if let drinkID = drink.id, let servingSize = drink.servingSize, let servingSizeUnit = drink.servingSizeUnit, let householdServingSize = drink.householdServingSize, let householdServingSizeUnit = drink.householdServingSizeUnit {
            logRef.setValue(["timestamp": timestamp, "drinkId": drinkID, "servingSize": servingSize, "servingSizeUOM": servingSizeUnit, "householdServingSize": householdServingSize, "householdServingSizeUOM" : householdServingSizeUnit], withCompletionBlock: {
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

    

    /* HYDRATION SETTINGS */
    var HYDRATE_SETTINGS_DB_REF = Database.database().reference().child("user-hydrate-settings")
    func observeHydrateSettings(withId id: String, completion: @escaping(HydrateSettings) -> Void){
        HYDRATE_SETTINGS_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let settings = HydrateSettings.transformHydrateSettings(data: data)
                completion(settings)
            }
        })
    }
    
    // Updates the isReminderEnabled value in Firebase
    func updateHydrationReminder(withValue value: Int) {
        HYDRATE_SETTINGS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).updateChildValues(["reminderFrequency" : value])
    }
    
    func updateHydrationTarget(withValue value: Int){
        HYDRATE_SETTINGS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).updateChildValues(["target" : value])
    }


    func observeHydrateDailies(withId id: String, completion: @escaping(HydrateDailies) -> Void){
        HYDRATE_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let dailies = HydrateDailies.transformHydrateDailies(data: data)
                completion(dailies)
            }
        })
    }
    
}


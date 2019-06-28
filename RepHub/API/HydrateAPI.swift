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
    var HYDRATE_LOGS_DB_REF = Database.database().reference().child("hydrate-logs")
    var USER_HYDRATE_LOGS_DB_REF = Database.database().reference().child("user-hydrate-logs")
    func observeHydrateLogs(withId id: String, completion: @escaping(HydrateLog) -> Void){
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayAtMidnight = cal.startOfDay(for: date).timeIntervalSince1970
        let ref = HYDRATE_LOGS_DB_REF.child(id)
        ref.child("timestamp").queryStarting(atValue: todayAtMidnight)
        ref.observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let log = HydrateLog.transformHydrateLog(data: data, key: snapshot.key)
                completion(log)
            }
        })
    }
    
    func removeHydrationLog(withLogId id: String, onSuccess: @escaping() -> Void) {
        USER_HYDRATE_LOGS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(id).removeValue()
        HYDRATE_LOGS_DB_REF.child(id).removeValue()
        onSuccess()
    }
    
    func saveHyrdationLog(withUserId id: String, drink: Drink) {
        let newRef = HYDRATE_LOGS_DB_REF.child(id).childByAutoId()
        let timestamp = NSDate().timeIntervalSince1970
        if let drinkID = drink.ndb_no, let servingSize = drink.servingSize, let servingSizeUnit = drink.servingSizeUnit, let householdServingSize = drink.householdServingSize, let householdServingSizeUnit = drink.householdServingSizeUnit {
            newRef.setValue(["timestamp": timestamp, "drinkId": drinkID, "servingSize": servingSize, "servingSizeUOM": servingSizeUnit, "householdServingSize": householdServingSize, "householdServingSizeUOM" : householdServingSizeUnit], withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
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


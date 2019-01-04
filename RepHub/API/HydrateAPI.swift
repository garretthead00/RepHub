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
    var HYDRATE_LOGS_DB_REF = Database.database().reference().child("hydrate-logs")
    var USER_HYDRATE_LOGS_DB_REF = Database.database().reference().child("user-hydrate-logs")
    var HYDRATE_SETTINGS_DB_REF = Database.database().reference().child("user-hydrate-settings")
    
    // listens to all events on the HydrateLog location of the database.
    func observeHydrateLogs(withId id: String, completion: @escaping(HydrateLog) -> Void){
        let query = HYDRATE_LOGS_DB_REF.child(id).queryOrdered(byChild: "timeStamp").queryLimited(toFirst: 25)
        query.observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let log = HydrateLog.transformHydrateLog(data: data, key: snapshot.key)
                completion(log)
            }
        })
        
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
    
    func observeHydrateSettings(withId id: String, completion: @escaping(HydrateSettings) -> Void){
        HYDRATE_SETTINGS_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let settings = HydrateSettings.transformHydrateSettings(data: data)
                completion(settings)
            }
        })
    }
    
    func removeHydrationLog(withLogId id: String, onSuccess: @escaping() -> Void) {
        USER_HYDRATE_LOGS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(id).removeValue()
        HYDRATE_LOGS_DB_REF.child(id).removeValue()
        onSuccess()
    }
    
    // Updates the isReminderEnabled value in Firebase
    func updateHydrationReminder(withValue value: Bool) {
        HYDRATE_SETTINGS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).updateChildValues(["isReminderEnabled" : value])
    }

    // Calculates the current daily intake and returns the value to the controller
    func updateDailyIntake(withValue value: Double, onSuccess: @escaping() -> Void) {
        HYDRATE_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).updateChildValues(["intake": value])
        onSuccess()
    }
    
}


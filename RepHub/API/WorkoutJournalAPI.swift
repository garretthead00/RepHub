//
//  WorkoutJournalAPI.swift
//  RepHub
//
//  Created by Garrett Head on 12/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import Firebase

class WorkoutJournalAPI {
    
    var WORKOUTJOURNAL_DB_REF = Database.database().reference().child("workout-journal")
    
    func observeWorkoutJournalEntries(completion: @escaping(JournalEntry) -> Void) {
        WORKOUTJOURNAL_DB_REF.observe(.childAdded, with: { snapshot in
            if let data = snapshot.value as? [String : Any] {
                let entry = JournalEntry.transformJournalEntry(data: data, key: snapshot.key)
                completion(entry)
            }
        })
    }
    
    func observeWorkoutJournalEntry(withId id: String, completion: @escaping(JournalEntry) -> Void){
        WORKOUTJOURNAL_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let entry = JournalEntry.transformJournalEntry(data: data, key: snapshot.key)
                completion(entry)
            }
        })
    }
    
    
    
    
}

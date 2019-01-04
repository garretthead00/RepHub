//
//  JournalEntry.swift
//  RepHub
//
//  Created by Garrett Head on 12/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class JournalEntry {
    
    var id : String?
    var timestamp : Int?
    var workoutLogId : String?
    var starRating : Int?
    var successComment : String?
    var failedComment : String?
    var comment : String?
    
}

extension JournalEntry {
    static func transformJournalEntry(data: [String: Any], key: String) -> JournalEntry {
        let entry = JournalEntry()
        entry.id = key
        entry.timestamp = data["timestamp"] as? Int
        entry.workoutLogId = data["workoutLog"] as? String
        entry.starRating = data["starRating"] as? Int
        entry.successComment = data["successComment"] as? String
        entry.failedComment = data["failedComment"] as? String
        entry.comment = data["comment"] as? String
        return entry
    }
}

//
//  UserJournalEntriesAPI.swift
//  RepHub
//
//  Created by Garrett Head on 12/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserJournalEntriesAPI {
    var USER_JOURNAL_ENTRIES_DB_REF = Database.database().reference().child("user-journal-entries")
}

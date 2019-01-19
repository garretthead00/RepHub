//
//  MuteAPI.swift
//  RepHub
//
//  Created by Garrett on 1/19/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MuteAPI {
    
    var MUTE_DB_REF = Database.database().reference().child("muted")
    
    // Adds the userID (id) to the current user's muted list.
    func muteUser(withId id: String) {
        if let currentUser = API.RepHubUser.CURRENT_USER {
            MUTE_DB_REF.child(currentUser.uid).child(id).setValue(true)
        }
    }
    
    // checks whether the current user has muted user with userID
    func isMuted(userId: String, completion: @escaping(Bool) -> Void) {
        if let currentUser = API.RepHubUser.CURRENT_USER {
            MUTE_DB_REF.child(currentUser.uid).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists(){
                    completion(true)
                }else{
                    completion(false)
                }
            })
        }
    }
    
    // Returns a list of userId's that the current User has muted.
    func observeMutedUsers(completion: @escaping(String) -> Void) {
        
        if let currentUser = API.RepHubUser.CURRENT_USER {
            MUTE_DB_REF.child(currentUser.uid).observe(.childAdded, with: {
                snapshot in
                completion(snapshot.key)
            })
        }
    }
}

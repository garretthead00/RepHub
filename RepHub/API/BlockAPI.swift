//
//  BlockAPI.swift
//  RepHub
//
//  Created by Garrett Head on 1/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


class BlockAPI {
    
    var BLOCKED_DB_REF = Database.database().reference().child("blocked")
    var BLOCKED_BY_DB_REF = Database.database().reference().child("blockedBy")
    
    
    func blockUser(withId id: String){
        if let currentUser = API.RepHubUser.CURRENT_USER {
            BLOCKED_DB_REF.child(currentUser.uid).child(id).setValue(true)
            BLOCKED_BY_DB_REF.child(id).child(currentUser.uid).setValue(true)
            API.Follow.FOLLOWERS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(id).setValue(NSNull())
            API.Follow.FOLLOWERS_DB_REF.child(id).child(API.RepHubUser.CURRENT_USER!.uid).setValue(NSNull())
            API.Follow.FOLLOWING_DB_REF.child(id).child(API.RepHubUser.CURRENT_USER!.uid).setValue(NSNull())
            API.Follow.FOLLOWING_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(id).setValue(NSNull())

            API.UserPosts.USER_POSTS_DB_REF.child(id).observeSingleEvent(of: .value, with: {
                snapshot in
                if let data = snapshot.value as? [String : Any] {
                    for key in data.keys {
                        Database.database().reference().child("feed").child(API.RepHubUser.CURRENT_USER!.uid).child(key).removeValue()
                    }
                }
            })
            API.UserPosts.USER_POSTS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
                snapshot in
                if let data = snapshot.value as? [String : Any] {
                    for key in data.keys {
                        Database.database().reference().child("feed").child(id).child(key).removeValue()
                    }
                }
            })
            
            let newNotificationReference = API.Notification.NOTIFICATION_DB_REF.child(id).child("\(API.RepHubUser.CURRENT_USER!.uid)-\(id)")
            newNotificationReference.setValue(NSNull())
            
            let newNotificationReferenceInverse = API.Notification.NOTIFICATION_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child("\(id)-\(API.RepHubUser.CURRENT_USER!.uid)")
            newNotificationReferenceInverse.setValue(NSNull())
                

        }
    }
    
    func unblockUser(withId id: String){
        print("unblockuser")
        if let currentUser = API.RepHubUser.CURRENT_USER {
            BLOCKED_DB_REF.child(currentUser.uid).child(id).removeValue()
            BLOCKED_BY_DB_REF.child(id).child(currentUser.uid).removeValue()

        }
    }
    
    func fetchBlockedUsers(completion: @escaping(String) -> Void) {
        if let currentUser = API.RepHubUser.CURRENT_USER {
            BLOCKED_DB_REF.child(currentUser.uid).observe(.childAdded, with: {
                snapshot in
                if let data = snapshot.key as? String {
                    completion(data)
                }
            })
        }
    }

    func fetchBlockedByUsers(completion: @escaping(String) -> Void) {
        if let currentUser = API.RepHubUser.CURRENT_USER {
            BLOCKED_BY_DB_REF.child(currentUser.uid).observe(.childAdded, with: {
                snapshot in
                if let data = snapshot.key as? String {
                    completion(data)
                }
            })
        }
    }

    func isBlocked(userId: String, completion: @escaping(Bool) -> Void) {
        if let currentUser = API.RepHubUser.CURRENT_USER {
            BLOCKED_BY_DB_REF.child(currentUser.uid).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                print("snapshot: \(snapshot.exists())")
                if snapshot.exists(){
                    completion(true)
                }else{
                    completion(false)
                }
            })
        }
    }
    
    
}

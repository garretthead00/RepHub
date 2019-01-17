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
    
    var BLOCK_DB_REF = Database.database().reference().child("block")
    
    
    func blockUser(withId id: String){
        if let currentUser = API.RepHubUser.CURRENT_USER {
            BLOCK_DB_REF.child(id).child(currentUser.uid).setValue(true, withCompletionBlock: {
                err, ref in
                //API.Follow.unFollowAction(withUser: id)
                API.Follow.FOLLOWERS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(API.RepHubUser.CURRENT_USER!.uid).setValue(NSNull())
                API.Follow.FOLLOWING_DB_REF.child(id).child(API.RepHubUser.CURRENT_USER!.uid).setValue(NSNull())
                
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
                API.Follow.FOLLOWERS_DB_REF.child(id).child(API.RepHubUser.CURRENT_USER!.uid).setValue(NSNull())
                API.Follow.FOLLOWING_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(id).setValue(NSNull())
                API.Follow.FOLLOWERS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(API.RepHubUser.CURRENT_USER!.uid).setValue(NSNull())
                API.Follow.FOLLOWING_DB_REF.child(id).child(API.RepHubUser.CURRENT_USER!.uid).setValue(NSNull())
                let newNotificationReference = API.Notification.NOTIFICATION_DB_REF.child(id).child("\(API.RepHubUser.CURRENT_USER!.uid)-\(id)")
                newNotificationReference.setValue(NSNull())
                
                
            })
        }
    }
    
    func unblockUser(withId id: String){
        if let currentUser = API.RepHubUser.CURRENT_USER {
            BLOCK_DB_REF.child(id).child(currentUser.uid).removeValue()

        }
    }
    
    func fetchBlockedUsers(completion: @escaping(String) -> Void) {
        if let currentUser = API.RepHubUser.CURRENT_USER {
            BLOCK_DB_REF.child(currentUser.uid).observe(.childAdded, with: {
                snapshot in
                if let data = snapshot.key as? String {
                    completion(data)
                }
            })
        }
    }
    
    
}

//
//  FollowAPI.swift
//  RepHub
//
//  Created by Garrett Head on 6/25/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowAPI {
    
    var FOLLOWING_DB_REF = Database.database().reference().child("following")
    var FOLLOWERS_DB_REF = Database.database().reference().child("followers")
    
    
    func followAction(withUser id: String) {
        API.UserPosts.USER_POSTS_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String : Any] {
                for key in data.keys {
                    if let value = data[key] as? [String : Any]{
                        let timestampPost = value["timestamp"] as! Int
                        Database.database().reference().child("feed").child(API.RepHubUser.CURRENT_USER!.uid).child(key).setValue(["timestamp": timestampPost])
                    }
                    
                }
            }
        })
        FOLLOWERS_DB_REF.child(id).child(API.RepHubUser.CURRENT_USER!.uid).setValue(true)
        FOLLOWING_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(id).setValue(true)
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        let newNotificationReference = API.Notification.NOTIFICATION_DB_REF.child(id).child("\(id)-\(API.RepHubUser.CURRENT_USER!.uid)")
        newNotificationReference.setValue(["from": API.RepHubUser.CURRENT_USER!.uid, "objectId": API.RepHubUser.CURRENT_USER!.uid, "type": "follow", "timestamp": timestamp])

    }
    
    func unFollowAction(withUser id: String){
        API.UserPosts.USER_POSTS_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String : Any] {
                for key in data.keys {
                    Database.database().reference().child("feed").child(API.RepHubUser.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        })
        FOLLOWERS_DB_REF.child(id).child(API.RepHubUser.CURRENT_USER!.uid).setValue(NSNull())
        FOLLOWING_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(id).setValue(NSNull())
        let newNotificationReference = API.Notification.NOTIFICATION_DB_REF.child(id).child("\(id)-\(API.RepHubUser.CURRENT_USER!.uid)")
        newNotificationReference.setValue(NSNull())
    }
    
    
    func isFollowing(userId: String, completed: @escaping(Bool) -> Void) {
        FOLLOWERS_DB_REF.child(userId).child(API.RepHubUser.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        })
    }
    
    func fetchFollowerCount(userId: String, completion: @escaping(Int) -> Void){
        FOLLOWERS_DB_REF.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    func fetchFollowingCount(userId: String, completion: @escaping(Int) -> Void){
        FOLLOWING_DB_REF.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    
    func fetchFollowing(forUserId uid:String, completion: @escaping(RepHubUser) -> Void){
        FOLLOWING_DB_REF.child(uid).observe(.childAdded, with: {
            snapshot in
            let followingUID = snapshot.key
            API.RepHubUser.observeUser(withId: followingUID, completion: {
                user in
                completion(user)
            })
        })
    }
    
    func fetchFollowers(forUserId uid:String, completion: @escaping(RepHubUser) -> Void){
        FOLLOWERS_DB_REF.child(uid).observe(.childAdded, with: {
            snapshot in
            let followingUID = snapshot.key
            API.RepHubUser.observeUser(withId: followingUID, completion: {
                user in
                completion(user)
            })
        })
    }
}

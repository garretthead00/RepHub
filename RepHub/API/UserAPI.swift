//
//  UserAPI.swift
//  
//
//  Created by Garrett Head on 6/20/18.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserAPI {
    
    var USERS_DB_REF = Database.database().reference().child("users")
    
    func observeUser(withId uid: String, completion: @escaping (RepHubUser) -> Void) {
        USERS_DB_REF.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let user = RepHubUser.transformUser(data: data, key: snapshot.key)
                completion(user)
            }
        })
    }

    func observerCurrentUser(completion: @escaping(RepHubUser) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
    USERS_DB_REF.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let user = RepHubUser.transformUser(data: data, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    var CURRENT_USER : User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    var CURRENT_USER_REF : DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return USERS_DB_REF.child(currentUser.uid)
    }
    
    func observeUsers(completion: @escaping(RepHubUser) -> Void){
       USERS_DB_REF.observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let user = RepHubUser.transformUser(data: data, key: snapshot.key)
                if user.uid! != self.CURRENT_USER?.uid {
                    completion(user)
                }
            }
        })
    }
    
    func queryUsers(withText text: String, completion: @escaping(RepHubUser) -> Void){
        USERS_DB_REF.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 25).observeSingleEvent(of: .value, with: {
            snapshot in
            snapshot.children.forEach({ (s) in
                let child  = s as! DataSnapshot
                if let data = child.value as? [String: Any] {
                    let user = RepHubUser.transformUser(data: data, key: child.key)
                    completion(user)
                }
            })
        })
    }
    
    
    func fetchTotalRepCount(userId: String, completion: @escaping(Int) -> Void){
        USERS_DB_REF.child(userId).observe(.value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let user = RepHubUser.transformUser(data: data, key: snapshot.key)
                let count = user.totalRepCount
                completion(count!)
                
            }
        })
    }
    
    func observeUserByName(username: String, completion: @escaping(RepHubUser) -> Void){
        USERS_DB_REF.queryOrdered(byChild: "username_lowercase").queryEqual(toValue: username).observeSingleEvent(of: .childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let user = RepHubUser.transformUser(data: data, key: snapshot.key)
                if user.uid! != self.CURRENT_USER?.uid {
                    completion(user)
                }
            }
        })
    }
    
    
}

//
//  MyPostsAPI.swift
//  RepHub
//
//  Created by Garrett Head on 6/30/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

import FirebaseDatabase

class MyPostsAPI {

    var MYPOSTS_DB_REF = Database.database().reference().child("myPosts")
    
    func fetchMyPosts(userId: String, completion: @escaping(String) -> Void) {
        MYPOSTS_DB_REF.child(userId).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
    
    func fetchMyPostCount(userId: String, completion: @escaping(Int) -> Void){
        MYPOSTS_DB_REF.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
}

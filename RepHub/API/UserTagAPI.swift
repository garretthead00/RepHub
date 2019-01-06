//
//  UserTagAPI.swift
//  RepHub
//
//  Created by Garrett on 1/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserTagAPI {
    
    var USERTAG_DB_REF = Database.database().reference().child("usertags")
    
    func fetchPosts(withUserId id: String, completion: @escaping(String) -> Void){
        USERTAG_DB_REF.child(id).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
}


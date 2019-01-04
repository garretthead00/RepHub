//
//  HashTagAPI.swift
//  RepHub
//
//  Created by Garrett Head on 7/4/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HashTagAPI {
    
    var HASHTAG_DB_REF = Database.database().reference().child("hashtags")
    
    func fetchPosts(withHashTag tag: String, completion: @escaping(String) -> Void){
        HASHTAG_DB_REF.child(tag.lowercased()).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
}

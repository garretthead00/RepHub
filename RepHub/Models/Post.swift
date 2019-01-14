//
//  Post.swift
//  RepHub
//
//  Created by Garrett Head on 6/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post {
    
    var caption : String?
    var photoUrl : String?
    var videoUrl : String?
    var uid: String?
    var id: String?
    var repCount : Int?
    var reps : Dictionary<String, Any?>?
    var isRepped : Bool?
    var saves : Dictionary<String, Any?>?
    var isSaved : Bool?
    var ratio: CGFloat?
    var timestamp : Int?

}

extension Post {
    static func transformPostPhoto(data: [String: Any], key: String) -> Post {
        let post = Post()
        post.uid = data["uid"] as? String
        post.caption = data["caption"] as? String
        post.photoUrl = data["photoUrl"] as? String
        post.videoUrl = data["videoUrl"] as? String
        post.id = key
        post.ratio = data["ratio"] as? CGFloat
        post.repCount = data["repCount"] as? Int
        post.reps = data["reps"] as? Dictionary<String, Any?>
        post.saves = data["saved"] as? Dictionary<String, Any?>
        post.timestamp = data["timestamp"] as? Int
        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.reps != nil {
                post.isRepped = post.reps![currentUserId] != nil
            }
            if post.saves != nil {
                post.isSaved = post.saves![currentUserId] != nil
            } else {
                post.isSaved = false
            }
        }
        return post
    }

}

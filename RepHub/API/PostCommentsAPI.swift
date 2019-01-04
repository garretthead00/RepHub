//
//  Post_CommentAPI.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostCommentsAPI {
    
    var POST_COMMENT_DB_REF = Database.database().reference().child("post-comments")

    
//    // listens to all events on the posts location of the database.
//    func observePostComments(withPostId: String, completion: @escaping(Comment) -> Void){
//        POST_COMMENT_DB_REF.observe(.childAdded) { (snapshot: DataSnapshot) in
//            if let data = snapshot.value as? [String: Any] {
//                let comment = Comment.transformComment(data: data)
//                completion(comment)
//            }
//        }
//    }
//
    
}

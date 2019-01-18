//
//  CommentAPI.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentAPI {
    
    var COMMENT_DB_REF = Database.database().reference().child("comments")
    
    // listens to all events on the posts location of the database.
    func observeComments(withCommentId id: String, completion: @escaping(Comment) -> Void){
        COMMENT_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let comment = Comment.transformComment(data: data, key: snapshot.key)
                completion(comment)
            }
        })
    }
    
    
}

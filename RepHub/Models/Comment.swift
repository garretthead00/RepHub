//
//  Comment.swift
//  RepHub
//
//  Created by Garrett Head on 6/19/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class Comment {
    var commentId : String?
    var commentText : String?
    var uid: String?
    
}

extension Comment {
    
    static func transformComment(data: [String: Any], key: String) -> Comment {
        let comment = Comment()
        comment.commentId = key as? String
        comment.uid = data["uid"] as? String
        comment.commentText = data["comment"] as? String
        return comment
    }
}

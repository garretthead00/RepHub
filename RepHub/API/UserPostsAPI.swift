//
//  UserPostsAPI.swift
//  RepHub
//
//  Created by Garrett Head on 6/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserPostsAPI {
    
    var USER_POSTS_DB_REF = Database.database().reference().child("user-post")

}

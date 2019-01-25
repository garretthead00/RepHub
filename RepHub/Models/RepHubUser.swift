//
//  User.swift
//  RepHub
//
//  Created by Garrett Head on 6/17/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class RepHubUser {

    var uid: String?
    var email: String?
    var profileImageUrl : String?
    var username : String?
    var isFollowing: Bool?
    var totalRepCount: Int?
    var firstName : String?
    var lastName : String?
    var dateOfBirth : String?
    var biologicalSex : String?
    var isBlocked : Bool?
    
}

extension RepHubUser {
    static func transformUser(data: [String: Any], key: String) -> RepHubUser {
        let user = RepHubUser()
        user.uid = key
        user.email = data["email"] as? String
        user.profileImageUrl = data["profileImage"] as? String
        user.username =  data["username"] as? String
        user.totalRepCount = data["totalRepCount"] as? Int
        user.firstName = data["firstName"] as? String
        user.lastName = data["lastName"] as? String
        user.biologicalSex = data["biologicalSex"]  as? String
        user.dateOfBirth = data["dateOfBirth"] as? String
        return user
    }
    

}

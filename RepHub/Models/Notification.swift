//
//  Notification.swift
//  RepHub
//
//  Created by Garrett Head on 7/7/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseAuth

class Notification {
    
    var from : String?
    var objectId : String?
    var type: String?
    var timestamp : Int?
    var id : String?
    
}

extension Notification {
    static func transformNotification(data: [String: Any], key: String) -> Notification {
        let notification = Notification()
        notification.from = data["from"] as? String
        notification.objectId = data["objectId"] as? String
        notification.type = data["type"] as? String
        notification.id = key
        notification.timestamp = data["timestamp"] as? Int
        return notification
    }
    
}

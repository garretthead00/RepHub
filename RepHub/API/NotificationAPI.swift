//
//  NotificationAPI.swift
//  RepHub
//
//  Created by Garrett Head on 7/7/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NotificationAPI {
    
    var NOTIFICATION_DB_REF = Database.database().reference().child("notifications")
    
    func observeNotification(withId id: String, completion: @escaping(Notification) -> Void) {
        NOTIFICATION_DB_REF.child(id).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String : Any] {
                let newNotification = Notification.transformNotification(data: data, key: snapshot.key)
                completion(newNotification)
                
            }
        })
    }

}

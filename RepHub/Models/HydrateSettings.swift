//
//  HydrateSettings.swift
//  RepHub
//
//  Created by Garrett Head on 7/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class HydrateSettings {
    
    var interval : String?
    var frequency : Int?
    var isReminderEnabled : Bool?
    
}

extension HydrateSettings {
    
    static func transformHydrateSettings(data: [String: Any]) -> HydrateSettings {
        let settings = HydrateSettings()
        settings.frequency = data["reminderFrequency"] as? Int
        settings.interval = data["reminderInterval"] as? String
        settings.isReminderEnabled = data["isReminderEnabled"] as? Bool
        return settings
    }
}

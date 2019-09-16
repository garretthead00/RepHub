//
//  HydrateSettings.swift
//  RepHub
//
//  Created by Garrett Head on 7/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class HydrateSettings {
    
    var target : Int?
    var frequency : Int?
    
}

extension HydrateSettings {
    
    static func transformHydrateSettings(data: [String: Any]) -> HydrateSettings {
        let settings = HydrateSettings()
        settings.frequency = data["reminderFrequency"] as? Int
        settings.target = data["target"] as? Int
        return settings
    }
}

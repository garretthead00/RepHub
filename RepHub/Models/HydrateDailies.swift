//
//  HydrateDailies.swift
//  RepHub
//
//  Created by Garrett Head on 7/25/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class HydrateDailies {
    
    var goal : Double?
    var intake : Double?
    
}

extension HydrateDailies {
    
    static func transformHydrateDailies(data: [String: Any]) -> HydrateDailies {
        let dailies = HydrateDailies()
        dailies.goal = data["goal"] as? Double
        dailies.intake = data["intake"] as? Double
        return dailies
    }
}

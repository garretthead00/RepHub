//
//  HydrateLog.swift
//  RepHub
//
//  Created by Garrett Head on 7/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class HydrateLog {
    
    var id : String?
    var oz : Double?
    var type : String?
    var timeStamp : Int?
    
}

extension HydrateLog {
    
    static func transformHydrateLog(data: [String: Any], key: String) -> HydrateLog {
        let log = HydrateLog()
        log.id = key
        log.oz = data["oz"] as? Double
        log.type = data["type"] as? String
        log.timeStamp = data["timestamp"] as? Int
        return log
    }
}

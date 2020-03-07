//
//  GlobalExtensions.swift
//  RepHub
//
//  Created by Garrett Head on 6/29/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

extension Double {
    func truncate(places : Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension Double {
    func convertTimeDateTime(fromTimestamp timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func getDateString(format: String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format // "MM-dd-yyyy HH:mm" Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}

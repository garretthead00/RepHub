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

//
//  ActivityLog.swift
//  RepHub
//
//  Created by Garrett Head on 11/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

protocol ActivityLog {
    
    
    var timestamp : Double { get }
    var unit : String { get }
    var value : Double { get }
    
}

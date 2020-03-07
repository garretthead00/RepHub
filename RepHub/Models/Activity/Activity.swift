//
//  Activity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


protocol Activity {
    var name : String { get }
    var icon : UIImage { get }
    var color : UIColor { get }
    var unit : String { get }
    var dailyTotal : Double? { get set }
    var remainingToTarget : Double? { get }
    var target : Double? { get set }
    var percentComplete : Double? { get }
    var percentRemaining : Double? { get }
    var summaryData : [(String, Double, String)]? { get set }
}


//
//  Activity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


protocol Activity {
    var label : String { get }
    var icon : UIImage { get }
    var color : UIColor { get }
    var unit : String { get }
    var dailyTotal : Double? { get set }
    var target : Double { get set }
    var percentComplete : Double? { get set }
    var percentRemaining : Double? { get set }
    var data : [(String,Double,String)] { get }
}


//
//  MindActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class MindActivity : Activity {
    var label: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    var dailyTotal: Double
    var target: Double
    var percentComplete: Double
    var percentRemaining: Double
    var data: [(String, Double, String)] = []
    
    init() {
        self.label = "Mind"
        self.icon = UIImage.Theme.Activity.mind
        self.color = UIColor.Theme.Activity.mind
        self.unit = "Minutes"
        self.dailyTotal = 15.0
        self.target = 30.0
        self.percentComplete = self.dailyTotal / self.target * 100
        self.percentRemaining = 100.0 - self.percentComplete
    }
}

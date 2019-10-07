//
//  EatActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/1/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


struct EatActivity {
    var dailyTotal : Double
    var target : Double
    var unit : String = "Calories"
    var engUnit : UnitEnergy = .calories
    var icon : UIImage = UIImage.Theme.Activity.eat
    var color : UIColor = UIColor.Theme.Activity.eat
    
    var dailyActivities : [(String,Double,String)]? {
        return nil
    }
    
    var data : [(String,Double, String)] {
        let thisData : [(String,Double, String)] = []
        return thisData
    }
    

}

// MARK: - Initializers
extension EatActivity {
    
    init() {
        self.target = 2000.0
        self.dailyTotal = 1450.0
    }
    

}

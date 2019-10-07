//
//  MindActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/1/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


struct MindActivity {
    
    var dailyTotal : Double
    var target : Double
    var unit : String = "minute"
    var engUnit : UnitDuration = .minutes
    var icon : UIImage = UIImage.Theme.Activity.mind
    var color : UIColor = UIColor.Theme.Activity.mind
    
    // MARK: - HealthKit Properties
    var mindfulMinutes : Double? = 0.0
    
    
    var dailyActivities : [(String,Double,String)]? {
        return nil
    }
    
    var data : [(String,Double, String)] {
        let thisData : [(String,Double, String)] = []
        return thisData
    }
    

    
}

// MARK: - Initializers
extension MindActivity {
    
    init() {
        self.target = 30.0
        self.dailyTotal = 10.0
    }
    

}

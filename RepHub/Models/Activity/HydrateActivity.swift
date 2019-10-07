//
//  HydrateActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/1/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


struct HydrateActivity {
    var dailyTotal : Double
    var target : Double
    var unit : String = "oz"
    var engUnit : UnitVolume = .fluidOunces
    var icon : UIImage = UIImage.Theme.Activity.hydrate
    var color : UIColor = UIColor.Theme.Activity.hydrate
    
    // MARK: - HealthKit Properties
    var waterDrank : Double? = 0.0
    var totalSugar : Double? = 0.0
    var totalCaffeine : Double? = 0.0
    var totalCaloriesConsumed : Double? = 0.0
    
    
    var dailyActivities : [(String,Double,String)]? {
        return nil
    }
    var data : [(String,Double, String)]{
        let thisData : [(String,Double, String)] = []
        return thisData
    }

}


// MARK: - Initializers
extension HydrateActivity {
    
    init() {
        self.target = 64.0
        self.dailyTotal = 48.0
    }

}

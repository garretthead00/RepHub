//
//  userBodyMeasurements.swift
//  RepHub
//
//  Created by Garrett Head on 9/22/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

class UserBodyMeasurements {
    

    var heightInMeters: Double?
    var weightInPounds: Double?
    var leanBodyMass : Double?
    var waistCircumference : Double?
    var bodyFatPercentage : Double?
    
    var bodyMassIndex: Double? {
        
        guard let weightInPounds = weightInPounds,
            let heightInMeters = heightInMeters,
            heightInMeters > 0 else {
                return nil
        }
        
        return ((weightInPounds*0.45359237)/(heightInMeters*heightInMeters))
    }
    
    func calculateBodyMassIndex(weight: Double, height: Double) -> Double? {
        if height > 0 {
            return ((weight*0.45359237)/(height*height))
        }else {
            return nil
        }
        
        
    }
}

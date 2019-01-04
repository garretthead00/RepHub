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
    var weightInKilograms: Double?
    
    var bodyMassIndex: Double? {
        
        guard let weightInKilograms = weightInKilograms,
            let heightInMeters = heightInMeters,
            heightInMeters > 0 else {
                return nil
        }
        
        return (weightInKilograms/(heightInMeters*heightInMeters))
    }
}

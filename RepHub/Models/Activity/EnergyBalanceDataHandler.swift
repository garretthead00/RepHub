//
//  EnergyBalanceDataHandler.swift
//  RepHub
//
//  Created by Garrett Head on 10/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

struct EnergyBalanceDataHandler {
    
    var energyBurned : [(Date, Double, HKUnit)]
    var energyConsumed : [(Date, Double, HKUnit)]
    var energyBalance : [(Date, Double, HKUnit)] = []
    
    init(energyBurned : [(Date, Double, HKUnit)], energyConsumed : [(Date, Double, HKUnit)]){
        self.energyConsumed = energyConsumed
        self.energyBurned = energyBurned
        self.calcualateEnergyBalance()
    }
    
    private mutating func calcualateEnergyBalance(){
        var balanceArray : [(Date, Double, HKUnit)] = []
        for i in 0 ..< self.energyBurned.count {
            let difference = self.energyConsumed[i].1 - self.energyBurned[i].1
            balanceArray.append((self.energyBurned[i].0, difference, self.energyBurned[i].2))
        }
        self.energyBalance = balanceArray
    }
    
}


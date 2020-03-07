//
//  EnergyBalanceDataHandler.swift
//  RepHub
//
//  Created by Garrett Head on 10/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

class EnergyBalanceDataHandler {
    
    var activeEnergyBurnedByHour : [(Date, Double, String)]?
    var restingEnergyBurnedByHour : [(Date, Double, String)]?
    var energyConsumedByHour : [(Date, Double, String)]?
    
    var energyBalanceByHour : [(Date, Double, String)]? {
        var energBurnedSum = 0.0
        var energyConsumedSum = 0.0
        var balanceArray : [(Date, Double, String)] = []
        if let energyBurned = self.activeEnergyBurnedByHour, let energyConsumed = self.energyConsumedByHour {
            for i in 0 ..< energyBurned.count {
                energBurnedSum += energyBurned[i].1
                energyConsumedSum += energyConsumed[i].1
                let difference = energyConsumedSum - energBurnedSum
                balanceArray.append((energyBurned[i].0, difference, energyBurned[i].2))
            }
        }
        return balanceArray
    }
    
    init(){
        print("energyBalance init")
        self.getEnergyBurned()
        self.getEnergyConsumed()
    }

}

extension EnergyBalanceDataHandler {
    
    private func getEnergyBurned(){
        print("getting energy burned per hour")
        ExerciseActivityStore.getHourlyActiveEnergyBurned(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            print("got energyBurned per hour")
            self.activeEnergyBurnedByHour = result
        }
    }
    
    private func getEnergyConsumed(){
        print("getting energy consumed per hour")
        EatActivityStore.getHourlyEnergyConsumedTotal(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            print("got energyConsumed per hour")
            self.energyConsumedByHour = result
        }
    }
    
    
}

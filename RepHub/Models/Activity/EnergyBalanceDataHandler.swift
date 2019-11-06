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
    
    var energyBurned : [(Date, Double, String)]? {
        didSet {
            self.calculateEnergyBalance()
        }
    }
    var energyConsumed : [(Date, Double, String)]? {
        didSet {
            self.calculateEnergyBalance()
        }
    }
    
    var energyBalance : [(Date, Double, String)]?
    
    init(){
        self.getEnergyBurned()
        self.getEnergyConsumed()
    }
    

    
}

extension EnergyBalanceDataHandler {
    
    private func getEnergyBurned(){
        ExerciseActivityStore.getHourlyActiveEnergyBurned(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            print("---- Energy Burned ---)")
            print("result \(result)")
            self.energyBurned = result
        }
    }
    
    private func getEnergyConsumed(){
        EatActivityStore.getHourlyEnergyConsumedTotal(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            print("---- Energy Consumed ---)")
            print("result \(result)")
            self.energyConsumed = result
        }
    }
    
    private func calculateEnergyBalance(){
        
        if let energyBurned = self.energyBurned, let energyConsumed = self.energyConsumed {
            var balanceArray : [(Date, Double, String)] = []
            for i in 0 ..< energyBurned.count {
                let difference = energyConsumed[i].1 - energyBurned[i].1
                balanceArray.append((energyBurned[i].0, difference, energyBurned[i].2))
            }
            print("---- Energy Balance ---)")
            print("result \(balanceArray)")
            self.energyBalance = balanceArray
        }
        

    }
    
}

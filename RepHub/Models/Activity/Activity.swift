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
    var dailyTotal : Double { get }
    var target : Double { get }
    var percentComplete : Double { get }
    var percentRemaining : Double { get }
    var data : [(String,Double,String)] { get }
}


//protocol ExerciseActivity : Activity {
//
//    var workoutsCompleted : Double? { get }
//    var flightsAscended : Double? { get }
//    var exerciseMinutes : Double? { get }
//    var totalActiveCalories : Double? { get }
//    var totalRestingCalories : Double? { get }
//    var distance : Double? { get }
//    var totalCaloriesBurned : Double? { get }
//    var standMinutes : Double? { get }
//    var totalSteps : Double? { get }
//
//}
//
//
//protocol MindActivity : Activity {
//    var mindfulMinutes : Double? { get }
//}
//
//protocol EatActivity : Activity {
//    var energyConsumed : Double? { get }
//    var totalFats : Double? { get }
//    var totalProtein : Double? { get }
//    var totalCarbs : Double? { get }
//}
//
//protocol HydrateActivity : Activity {
//    var amountDrank : Double? { get }
//    var totalSugar : Double? { get }
//    var totalWater : Double? { get }
//    var totalCaffeine : Double? { get }
//}

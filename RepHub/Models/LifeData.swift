//
//  LifeData.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import UIKit


enum LifeTypes : String  {
    case mind = "Mind"
    case exercise = "Exercise"
    case eat = "Eat"
    case water = "Water"
}

let lifeValues : [Double] = [723.0,58.0,1650.0,23.0]
let lifeTargets : [Double] = [1500,62.0,2000.0,30.0]
let lifeColors : [UIColor] = [UIColor.Theme.salmon,UIColor.Theme.aqua, UIColor.Theme.seaFoam, UIColor.Theme.lavender]
let lifeLabels : [String] = ["Exercise","Water","Eat","Mind"]


struct LifeData {
    
    var value : Double?
    var target : Double?
    var percentCompleted : Double?
    var remainingFromTarget : Double?
    var color : UIColor?
    var icon : UIImage?
    var data : LifeTypes?
    var label : String?
    
    init(value: Double, target: Double) {
        self.value = value
        self.target = target
        self.remainingFromTarget = target - value
        self.percentCompleted = target / value * 100
        
    }
    
    init(value: Double, target: Double, color: UIColor, data: LifeTypes, icon: UIImage) {
        self.value = value
        self.target = target
        self.remainingFromTarget = target - value
        self.percentCompleted = value / target * 100
        self.color = color
        self.data = data
        self.icon = icon
        //self.label =
        
    }
    
    init(value: Double, target: Double, color: UIColor, icon: UIImage) {
        self.value = value
        self.target = target
        self.remainingFromTarget = target - value
        self.percentCompleted = value / target * 100
        self.color = color
        self.icon = icon
    }
    
}

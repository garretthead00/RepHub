//
//  LifeDataCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class LifeDataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    

    var activityData : ActivityData?{
        didSet {
            self.updateView()
        }
    }
    
    var activity : Activity? {
        didSet {
            self.updateView()
        }
    }
    
    var percentComplete : Double?
    var percentRemaining : Double?
    var label : String?
    var icon : UIImage?
    var color : UIColor?
    var dailyTotal : Double?
    var target : Double?
    
    
    
    override func awakeFromNib() {
        self.titleLabel.text = ""
        self.valueLabel.text = "..."
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
    }

    
    
    private func updateView(){
        
        switch self.activity {
            case .mind(let mind):
                self.icon = mind.icon
                self.color = mind.color
                self.label = mind.label
                self.target = mind.target
                self.dailyTotal = mind.dailyTotal
            case .exercise(let exercise):
                self.icon = exercise.icon
                self.color = exercise.color
                self.label = exercise.label
                self.target = exercise.target
                self.dailyTotal = exercise.dailyTotal
            case .eat(let eat):
                self.icon = eat.icon
                self.color = eat.color
                self.label = eat.label
                self.target = eat.target
                self.dailyTotal = eat.dailyTotal
            case .hydrate(let hydrate):
                self.icon = hydrate.icon
                self.color = hydrate.color
                self.label = hydrate.label
                self.target = hydrate.target
                self.dailyTotal = hydrate.dailyTotal
            default:
                self.icon = nil
                self.color = nil
                self.label = ""
                self.target = 0.0
                self.dailyTotal = 0.0
        }
        
        
        
        
        self.layer.borderColor = self.color!.withAlphaComponent(0.5).cgColor
        self.titleLabel.textColor = self.color!
        self.valueLabel.textColor = self.color!
        self.titleLabel.text = self.label!
        self.valueLabel.text = "\(self.dailyTotal!)/\(self.target!) ..."
    }
}

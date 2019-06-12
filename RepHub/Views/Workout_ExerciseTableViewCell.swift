//
//  Workout_ExerciseTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 5/20/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol Workout_ExerciseDelegate {
    func setTarget(cell: Workout_ExerciseTableViewCell)
    func setBreak(cell: Workout_ExerciseTableViewCell)
}

class Workout_ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var breakLabel: UILabel!
    @IBOutlet weak var targetButton: UIButton!
    @IBOutlet weak var breakButton: UIButton!
    var delegate : Workout_ExerciseDelegate?

    var targetReps : String?
    var exercise : WorkoutExercise? {
        didSet {
            print("updated exercise cell...")
            updateView()
        }
    }
    
    var isTargetSet : Bool = false
    var targetString : String? {
        didSet {
            updateView()
        }
    }
    var isBreakSet : Bool = false
    var breakString : String? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.text = ""
        self.targetLabel.text = ""
        self.breakLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView(){
        self.nameLabel.text = self.exercise!.name
        if self.targetString != nil {
            self.targetButton.setImage(UIImage(named: "target_green"), for: .normal)
        } else {
            self.targetButton.setImage(UIImage(named: "target_lightGrey"), for: .normal)
        }
        if self.breakString != nil {
            self.breakButton.setImage(UIImage(named: "timer_blue"), for: .normal)
        } else {
            self.breakButton.setImage(UIImage(named: "timer_lightGrey"), for: .normal)
        }
        
        
        
        if let sets = self.exercise?.sets, sets > 0 , let target = self.exercise?.target, target > 0 {
            if let unit = self.exercise?.metricUnit {
                if unit != "Repitition" {
                    self.targetLabel.text = "\(sets) x \(target) \(unit)"
                }
                else {
                    self.targetLabel.text = "\(sets) x \(target)"
                    
                }
            }
            
        }
        
        
        
//        self.targetLabel.text = self.targetString
        self.breakLabel.text = self.breakString
    }
    
    @IBAction func targetButton_TouchUpInside(_ sender: Any) {
        print("set Target")
        self.delegate?.setTarget(cell: self)
    }
    
    @IBAction func breakButton_TouchUpInside(_ sender: Any) {
        print("set Break")
        self.delegate?.setBreak(cell: self)
    }
    
}

//
//  WorkoutExerciseCollectionReusableView.swift
//  RepHub
//
//  Created by Garrett Head on 2/7/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol WorkoutExerciseDelegate {
    func setBreak(withId id: String)
}

class WorkoutExerciseCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var setBreakButton: UIButton!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var breakButton: UIButton!
    
    var delegate : WorkoutExerciseDelegate?
    
    var exerciseName : String? {
        didSet {
            updateView()
        }
    }
    
    var breakTime : Int? {
        didSet {
            updateView()
        }
        
    }
    
    var workoutExerciseId : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clear()
    }
    
    private func clear(){
        self.exerciseNameLabel.text = ""
        
    }
    
    private func updateView() {
        self.exerciseNameLabel.text = exerciseName
        
        if let count = self.breakTime, count > 0 {
            self.setBreakButton.isHidden = true
            self.breakTimeLabel.isHidden = false
            self.breakButton.isHidden = false
            self.breakTimeLabel.text = String(count)
            self.breakButton.addTarget(self, action: #selector(self.setBreak), for: .touchUpInside)
        } else {
            self.setBreakButton.isHidden = false
            self.breakTimeLabel.isHidden = true
            self.breakButton.isHidden = true
            self.setBreakButton.addTarget(self, action: #selector(self.setBreak), for: .touchUpInside)
        }
        
    }
    
    @objc private func setBreak() {
        delegate?.setBreak(withId: workoutExerciseId!)
    }
}


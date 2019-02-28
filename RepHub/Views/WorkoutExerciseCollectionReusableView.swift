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
    func setTarget(withId id: String)
}

class WorkoutExerciseCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var setBreakButton: UIButton!
    @IBOutlet weak var setTargetButton: UIButton!
    var delegate : WorkoutExerciseDelegate?
    
    var exerciseName : String? {
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
        self.setBreakButton.addTarget(self, action: #selector(self.setBreak), for: .touchUpInside)
        self.setTargetButton.addTarget(self, action: #selector(self.setTarget), for: .touchUpInside)
    }
    
    @objc private func setBreak() {
        delegate?.setBreak(withId: workoutExerciseId!)
    }
    @objc private func setTarget() {
        delegate?.setTarget(withId: workoutExerciseId!)
    }
}

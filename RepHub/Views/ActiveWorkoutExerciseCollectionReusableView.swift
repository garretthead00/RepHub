//
//  ActiveWorkoutExerciseCollectionReusableView.swift
//  RepHub
//
//  Created by Garrett Head on 3/2/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ActiveWorkoutExerciseDelegate {
    func startBreak(countdown: Int)
}

class ActiveWorkoutExerciseCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var startBreakButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    
    
    var delegate : ActiveWorkoutExerciseDelegate?
    var exerciseName : String? {
        didSet {
            updateView()
        }
    }
    var countdown : Int? {
        didSet {
            updateView()
        }
    }
    var workoutExerciseId : String?

    var isTimerRunning = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clear()
    }
    
    private func clear(){
        self.exerciseNameLabel.text = ""
        self.countdownLabel.text = ""
        
    }
    
    private func updateView() {
        self.exerciseNameLabel.text = exerciseName
        if let count = countdown, count > 0 {
           self.countdownLabel.text = String(count)
        } else {
            self.countdownLabel.text = "0"
        }
        self.startBreakButton.addTarget(self, action: #selector(self.startBreak), for: .touchUpInside)
    }
    
    @objc private func startBreak() {
        if let count = countdown, count > 0 {
            // Has a set breaktime. Run the break clock.
            self.delegate?.startBreak(countdown: count)
        } else {
            // NO set breaktime. Run break clock with count = 0. (Prompts break selector from the controller.)
            self.delegate?.startBreak(countdown: 0)
        }
    }
    

}

//
//  ActiveWorkoutExerciseCollectionReusableView.swift
//  RepHub
//
//  Created by Garrett Head on 3/2/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ActiveWorkoutExerciseDelegate {
    func startBreak() -> Int
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
    var timer = Timer()
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
        print("trying a break")
        if let count = countdown, count > 0 {
            runTimer()
        } else {
            
            var count = 0
            count = (self.delegate?.startBreak())!
            print("count set to \(count)")
            print("running timer")
            self.countdown = count
            self.runTimer()
            
        }

    }
    

    
    private func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer(){
        if var count = self.countdown, count > 0 {
            count = count - 1
            self.countdown = count
            self.countdownLabel.text = "\(count)"
        } else {
            timer.invalidate()
            self.countdownLabel.text = "0"
        }
    }
    

}

//
//  WorkoutExerciseCollectionReusableView.swift
//  RepHub
//
//  Created by Garrett Head on 2/7/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class WorkoutExerciseCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var exerciseNameLabel: UILabel!
    
    var exerciseName : String? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clear()
    }
    
    private func clear(){
        self.exerciseNameLabel.text = ""
        
    }
    
    private func updateView() {
        self.exerciseNameLabel.text = exerciseName
    }
}

//
//  CreateWorkout_ExerciseTypeCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 5/17/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol CreateWorkout_ExerciseTypeDelegate {
    func goToExercisesForType(exerciseType: String)
}

class CreateWorkout_ExerciseTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var delegate : CreateWorkout_ExerciseTypeDelegate?
    var exerciseType : String? {
        didSet{
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.text = ""
    }
    
    private func updateView(){
        self.label.text = self.exerciseType
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.goToExercisesForType(exerciseType: self.exerciseType!)
    }
    
}



//
//  ExerciseTypesCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 4/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ExerciseTypeDelegate {
    func goToExercisesForType(exerciseType: String)
}

class ExerciseTypesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    var delegate : ExerciseTypeDelegate?
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

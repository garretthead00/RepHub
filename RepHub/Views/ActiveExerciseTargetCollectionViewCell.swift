//
//  ActiveExerciseTargetCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 3/2/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ActiveExerciseTargetSetDelegate {
    func addExerciseLog(forSet: Int)
}


class ActiveExerciseTargetCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var setTextField: UITextField!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    
    var delegate : ActiveExerciseTargetSetDelegate?
    var setBorderColor : CGColor?
    var setBackgroundColor : CGColor?
    
    var exerciseSet : ExerciseSet? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTextField.text = ""
        self.setTextField.placeholder = "#"
        self.weightTextField.text = ""
        self.weightTextField.placeholder = "lbs"
        self.repLabel.text = "#"
    }
    
    private func updateView() {
        self.setTextField.layer.cornerRadius = 15.0
        self.setTextField.layer.borderWidth = 2.0
        self.setTextField.layer.borderColor = self.setBorderColor
        self.setTextField.layer.backgroundColor = self.setBackgroundColor
        self.weightTextField.layer.cornerRadius = 15.0
        self.weightTextField.layer.borderWidth = 2.0
        self.weightTextField.layer.borderColor = self.setBorderColor
        self.weightTextField.layer.backgroundColor = self.setBackgroundColor
        let setStr = String(self.exerciseSet!.set! + 1)
        let weightStr = String(self.exerciseSet!.weight!)
        let repsStr = String(self.exerciseSet!.reps!)
        self.setTextField.text = setStr
        self.weightTextField.text = weightStr
        self.repLabel.text = repsStr
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.addExerciseLog(forSet: self.exerciseSet!.set!)
    }
    
}

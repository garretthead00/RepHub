//
//  ExeriseTargetSetCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 2/4/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ExerciseTargetSetDelegate {
    func promptExerciseSetMenu(cell: ExeriseTargetSetCollectionViewCell)
    func editSet(cell: ExeriseTargetSetCollectionViewCell)
    func addSet()
}



class ExeriseTargetSetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var setTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repLabel: UILabel!
    
    var delegate : ExerciseTargetSetDelegate?
    var setBorderColor : CGColor?
    var setBackgroundColor : CGColor?
    var thisSet : ExerciseSet? {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTextField.text = ""
        self.setTextField.placeholder = ""
        self.weightTextField.text = ""
        self.weightTextField.placeholder = "lbs"
        self.repLabel.text = ""
    }
    
    private func updateView() {
        
        if thisSet?.set == 0, thisSet?.reps == 0, thisSet?.weight == 0.0 {
            self.setTextField.layer.borderColor = UIColor.lightGray.cgColor
            self.setTextField.layer.backgroundColor = UIColor.lightGray.cgColor
            self.weightTextField.layer.borderColor = UIColor.lightGray.cgColor
            self.weightTextField.layer.backgroundColor = UIColor.lightGray.cgColor
            self.repLabel.textColor = UIColor.clear
        } else {
            self.setTextField.layer.borderColor = UIColor.lightGray.cgColor
            self.setTextField.layer.backgroundColor = UIColor.darkGray.cgColor
            self.weightTextField.layer.borderColor = UIColor.lightGray.cgColor
            self.weightTextField.layer.backgroundColor = UIColor.darkGray.cgColor
            self.repLabel.textColor = UIColor.lightGray
        }
        
        self.setTextField.layer.cornerRadius = 15.0
        self.setTextField.layer.borderWidth = 1.0
        self.weightTextField.layer.cornerRadius = 15.0
        self.weightTextField.layer.borderWidth = 1.0
        let setStr = String(self.thisSet!.set! + 1)
        let weightStr = String(self.thisSet!.weight!)
        let repsStr = String(self.thisSet!.reps!)
        self.setTextField.text = setStr
        self.weightTextField.text = weightStr
        self.repLabel.text = repsStr
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.weightTextField.text == "+" {
            delegate?.addSet()
        } else {
            delegate?.editSet(cell: self)
        }
        //delegate?.promptExerciseSetMenu(cell: self)
    }
}


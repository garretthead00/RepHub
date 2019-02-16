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
}

class ExerciseSet {
    var set : Int?
    var weight : Double?
    var reps : Int?
    
    init(set: Int, weight: Double, reps: Int) {
        self.set = set
        self.weight = weight
        self.reps = reps
    }
}

class ExeriseTargetSetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var setTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repLabel: UILabel!
    
    var delegate : ExerciseTargetSetDelegate?
    
    var thisSet : ExerciseSet? {
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
        
        let setStr = String(self.thisSet!.set! + 1)
        let weightStr = String(self.thisSet!.weight!)
        let repsStr = String(self.thisSet!.reps!)
        self.setTextField.text = setStr
        self.weightTextField.text = weightStr
        self.repLabel.text = repsStr
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.promptExerciseSetMenu(cell: self)
    }
}

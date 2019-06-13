//
//  ExercisesForWorkoutTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/17/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol ExerciseForWorkoutCellDelegate {
    func addExercise(id: String)
    func removeExercise(id:String)
}

class ExercisesForWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    var delegate : ExerciseForWorkoutCellDelegate?
    var exercise : Exercise? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    private func updateView(){
        self.nameLabel.text = self.exercise?.name
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let id = exercise?.id {
            if self.accessoryType == .checkmark {
                print("remove exercise with id: \(id)")
                self.accessoryType = .none
                delegate?.removeExercise(id: id)
            } else {
                print("add exercise with id: \(id)")
                self.accessoryType = .checkmark
                delegate?.addExercise(id: id)
                
            }
        }
    }

}

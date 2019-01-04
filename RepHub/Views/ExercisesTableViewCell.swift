//
//  ExercisesTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/10/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol ExerciseCellDelegate {
    func gotoExerciseVC(exerciseId: String?)
}

class ExercisesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    var delegate : ExerciseCellDelegate?
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
            delegate?.gotoExerciseVC(exerciseId: id)
            print("excerice cell touches ended")
        }
    }
    
    



    

}

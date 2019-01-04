//
//  ExercisesForWorkoutTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/17/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class ExercisesForWorkoutTableViewCell: UITableViewCell {

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

}

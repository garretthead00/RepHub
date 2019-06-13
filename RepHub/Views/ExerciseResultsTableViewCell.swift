//
//  ExerciseResultsTableViewCell.swift
//  
//
//  Created by Garrett Head on 5/28/19.
//

import UIKit

class ExerciseResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score : Int?
    var restTime : Int?
    var exercise : WorkoutExercise? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.text = ""
            self.restLabel.text = ""
            self.scoreLabel.text = ""
    }

    private func updateView(){
        self.nameLabel.text = self.exercise?.name
        self.restLabel.text = "\(restTime!)"
        self.scoreLabel.text = "\(score!) %"
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

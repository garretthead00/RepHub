//
//  WorkoutControlsTableViewCell.swift
//  
//
//  Created by Garrett Head on 2/27/19.
//

import UIKit

protocol WorkoutControlsDelegate {
    func startWorkout()
}

class WorkoutControlsTableViewCell: UITableViewCell {

    @IBOutlet weak var startWorkoutButton: UIButton!
    var delegate : WorkoutControlsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func startWorkout(_ sender: Any) {
        delegate?.startWorkout()
    }
    
}

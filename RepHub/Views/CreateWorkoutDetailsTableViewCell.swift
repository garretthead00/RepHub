//
//  CreateWorkoutDetailsTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/15/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class CreateWorkoutDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var workoutDescriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        workoutDescriptionTextView.layer.cornerRadius = 5.0
        workoutDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        workoutDescriptionTextView.layer.borderWidth = 0.5;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

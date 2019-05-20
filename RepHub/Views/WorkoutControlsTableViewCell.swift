//
//  WorkoutControlsTableViewCell.swift
//  
//
//  Created by Garrett Head on 2/27/19.
//

import UIKit

protocol WorkoutControlsDelegate {
    func startWorkout()
    func updateName(name: String)
    func updateDescription(description: String)
}

class WorkoutControlsTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startWorkoutButton: UIButton!
    var delegate : WorkoutControlsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionTextView.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func startWorkout(_ sender: Any) {
        delegate?.startWorkout()
    }
    @IBAction func nameTextField_TextChanged(_ sender: Any) {
        if let name = self.nameTextField.text {
            print("nameTextField_TextChanged")
            //delegate?.updateName(name: name)
        }
    }
    
  
    
}

extension WorkoutControlsTableViewCell : UITextViewDelegate {

    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        //delegate?.updateDescription(description: textView.text)
    }
}

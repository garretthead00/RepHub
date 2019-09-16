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
    var placeholderLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Description"
        placeholderLabel.font = descriptionTextView.font
        placeholderLabel.sizeToFit()
        descriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
        
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
            delegate?.updateName(name: name)
        }
    }
    
}

extension WorkoutControlsTableViewCell : UITextViewDelegate {

    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        if let desc = self.descriptionTextView.text {
            print("descriptionTextView_TextChanged")
            delegate?.updateDescription(description: desc)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

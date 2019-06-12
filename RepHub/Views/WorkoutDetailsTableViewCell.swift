//
//  WorkoutDetailsTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/17/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol WorkoutDetailsDelegate {
    func updateName(name: String)
    func updateDescription(description: String)
}

class WorkoutDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var workoutDescriptionTextView: UITextView!
    var delegate : WorkoutDetailsDelegate?
    var workout : Workout? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        workoutDescriptionTextView.layer.cornerRadius = 5.0
        workoutDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        workoutDescriptionTextView.layer.borderWidth = 0.5;
        workoutNameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
    }
    
    private func updateView(){
        self.workoutNameTextField.text = workout?.name
        self.workoutDescriptionTextView.text = workout?.description
        self.workoutDescriptionTextView.delegate = self
    }
    
    
    @IBAction func updateName(_ sender: Any) {
        print("changing workoutName...")
        self.workout?.name = self.workoutNameTextField.text
        delegate?.updateName(name: self.workout!.name!)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if self.isEditing {
            workoutNameTextField.isUserInteractionEnabled = true
            workoutNameTextField.layer.cornerRadius = 5.0
            workoutNameTextField.layer.borderColor = UIColor.lightGray.cgColor
            workoutNameTextField.layer.borderWidth = 0.5;
            workoutDescriptionTextView.isUserInteractionEnabled = true
        } else {
            workoutNameTextField.isUserInteractionEnabled = false
            workoutNameTextField.layer.cornerRadius = 0.0
            workoutNameTextField.layer.borderColor = UIColor.clear.cgColor
            workoutNameTextField.layer.borderWidth = 0.0;
            workoutDescriptionTextView.isUserInteractionEnabled = false
        }
    }

}

extension WorkoutDetailsTableViewCell : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print("changing description...")
        self.workout?.description = self.workoutDescriptionTextView.text
        delegate?.updateDescription(description: self.workout!.description!)
        
    }
}

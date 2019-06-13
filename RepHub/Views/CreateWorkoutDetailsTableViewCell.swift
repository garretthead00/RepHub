//
//  CreateWorkoutDetailsTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/15/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol CreateWorkoutDetailsDelegate {
    func updateName(name: String)
    func updateDescription(description: String)
}


class CreateWorkoutDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var workoutDescriptionTextView: UITextView!
    var delegate : CreateWorkoutDetailsDelegate?
    var placeholderLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        workoutNameTextField.becomeFirstResponder()
        workoutNameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.init(name: "Chalkduster", size: 18.0)!
            ])
        workoutDescriptionTextView.delegate = self
        workoutDescriptionTextView.selectedTextRange = workoutDescriptionTextView.textRange(from: workoutDescriptionTextView.beginningOfDocument, to: workoutDescriptionTextView.beginningOfDocument)
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Description"
        placeholderLabel.font = workoutDescriptionTextView.font
        placeholderLabel.sizeToFit()
        workoutDescriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (workoutDescriptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !workoutDescriptionTextView.text.isEmpty

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        print("myTargetFunction")
    }
    
    @IBAction func nameTextField_TextDidChange(_ sender: Any) {
        if let name = self.workoutNameTextField.text {
            print("nameTextField_TextChanged")
            delegate?.updateName(name: name)
        }
    }

}

extension CreateWorkoutDetailsTableViewCell : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        if let desc = self.workoutDescriptionTextView.text {
            print("descriptionTextView_TextChanged")
            delegate?.updateDescription(description: desc)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        // Combine the textView text and the replacement text to
//        // create the updated text string
//        let currentText:String = textView.text
//        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
//
//        // If updated text view will be empty, add the placeholder
//        // and set the cursor to the beginning of the text view
//        if updatedText.isEmpty {
//
//            textView.text = "Description"
//            textView.textColor = UIColor.lightGray
//
//            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//        }
//
//            // Else if the text view's placeholder is showing and the
//            // length of the replacement string is greater than 0, set
//            // the text color to black then set its text to the
//            // replacement string
//        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
//            textView.textColor = UIColor.white
//            textView.text = text
//        }
//
//            // For every other case, the text should change with the usual
//            // behavior...
//        else {
//            return true
//        }
//
//        // ...otherwise return false since the updates have already
//        // been made
//        return false
//    }
//
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        if self.window != nil {
//            if textView.textColor == UIColor.lightGray {
//                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//            }
//        }
//    }
}





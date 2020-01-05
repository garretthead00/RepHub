//
//  CreateDrinkDescriptionView.swift
//  RepHub
//
//  Created by Garrett Head on 1/5/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class CreateDrinkDescriptionView: UITableViewCell {

    @IBOutlet weak var descriptionTextView: UITextView!
    var drinkDescription : String?
    var delegate : CreateFoodDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionTextView.text = ""
        self.descriptionTextView.delegate = self
        self.drinkDescription = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CreateDrinkDescriptionView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text!)
        self.drinkDescription = self.descriptionTextView.text
        if let description = self.drinkDescription {
            delegate?.updateDescription(description: description)
        }
        
    }
    
}

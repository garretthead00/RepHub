//
//  DrinkDetailsTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 6/22/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class DrinkDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var nutritionFactsLabel: UILabel!
    
    var name : String? {
        didSet {
            self.updateView()
        }
    }
    var servingSize : String = ""
    var nutritionFactsMessage : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.name = ""
        self.servingSize = ""
        self.nutritionFactsLabel.text = ""
    }

    private func updateView(){
        self.nameLabel.text = self.name
        self.servingSizeLabel.text = self.servingSize
        self.nutritionFactsLabel.text = self.nutritionFactsMessage
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

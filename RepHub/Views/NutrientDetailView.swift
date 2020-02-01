//
//  NutrientDetailView.swift
//  RepHub
//
//  Created by Garrett Head on 1/12/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class NutrientDetailView: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var nutrient : (String, Double, String)? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.valueLabel.text = ""
        self.nameLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateView(){
     
        if let nutrient = self.nutrient {
            self.nameLabel.text = nutrient.0
            self.valueLabel.text = "\(Int(nutrient.1)) \(nutrient.2)"
        }

    }

}

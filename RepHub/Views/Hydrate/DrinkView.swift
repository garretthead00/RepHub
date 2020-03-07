//
//  DrinkView.swift
//  RepHub
//
//  Created by Garrett Head on 3/7/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class DrinkView: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    var drink : FoodItem? {
        didSet {
            self.updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.icon.image = UIImage.Theme.Activity.eat
        self.name.text = ""
        self.detail.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateView(){
        if let drink = self.drink {
            if let category = drink.category {
                self.icon.image = UIImage(named: category)
            }
            if let name = drink.name {
                self.name.text = name
            }
            if let serving = drink.householdServingSize, let unit = drink.householdServingSizeUnit {
                self.detail.text = "\(serving) \(unit)"
            }
            
            
        }
    }

}

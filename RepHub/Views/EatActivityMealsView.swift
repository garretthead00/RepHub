//
//  EatActivityMealsView.swift
//  RepHub
//
//  Created by Garrett Head on 1/12/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class EatActivityMealsView: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    var mealStr = ["Meals"]
    
    var meals : [String]? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.text = ""
        self.meals = self.mealStr
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateView(){
        if let meals = self.meals {
            self.label.text = meals[0]
        }
        
    }

}

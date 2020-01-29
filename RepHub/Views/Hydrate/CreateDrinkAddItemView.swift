//
//  CreateDrinkAddItemView.swift
//  Charts
//
//  Created by Garrett Head on 1/5/20.
//

import UIKit

class CreateDrinkAddItemView: UITableViewCell {

    @IBOutlet weak var addLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func add(_ sender: Any) {
        if let label = self.addLabel.text {
            print("add --\(label)")
        }
        
    }
    
}

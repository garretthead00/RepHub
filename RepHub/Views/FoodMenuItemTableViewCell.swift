//
//  FoodMenuItemTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/28/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class FoodMenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    var title : String? {
        didSet {
            updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateView(){
        self.itemImageView.image = UIImage(named: self.title!)
        self.itemLabel.text = self.title!
    }
    
}

//
//  LockerMenuTableViewCell.swift
//  RepHub
//
//  Created by Garrett on 1/7/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class LockerMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuOptionLabel: UILabel!
    @IBOutlet weak var menuOptionImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

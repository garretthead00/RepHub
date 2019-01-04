//
//  PlannerRecentActivityTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 7/22/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class PlannerRecentActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var caption: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.activityImageView.image = UIImage(named: "stats")
        self.caption.text = "user logged an activity..."
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

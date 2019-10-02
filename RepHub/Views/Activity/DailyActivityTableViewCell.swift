//
//  DailyActivityTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/19/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class DailyActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    var activity : Activity? {
        didSet {
            self.updateView()
        }
    }
    
    var activities : (String,Double,String)? {
        didSet {
            self.updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("daily activity awake")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    private func updateView(){
        print("activities \(self.activities!)")
        self.titleLabel.text = self.activities!.0
        if self.activities!.2 != "" {
            self.valueLabel.text = "\(Int(self.activities!.1)) \(self.activities!.2)"
        } else {
            self.valueLabel.text = "\(Int(self.activities!.1))"
        }
        
    }
}

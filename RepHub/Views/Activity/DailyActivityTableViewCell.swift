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
    
//    var dataSet : ActivityData? {
//        didSet {
//            self.updateView()
//        }
//    }

    var activity : Activity? {
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
        
        self.titleLabel.text = self.activity!.label
        if self.activity!.unit != nil {
            self.valueLabel.text = "\(Int(self.activity!.dailyTotal!)) \(self.activity!.unit!)"
        } else {
            self.valueLabel.text = "\(Int(self.activity!.dailyTotal!))"
        }
        
        
    }
}

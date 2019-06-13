//
//  HydrateStatusTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 6/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class HydrateStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var targetButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    

    var date : String?
    var targetStr : String?
    var score : Int? {
        didSet{
            self.updateView()
        }
    }
    var alarmOn : Bool = false {
        didSet{
            self.updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateLabel.text = ""
        self.targetLabel.text = ""
        self.scoreLabel.text = ""
    }
    
    private func updateView() {
        self.dateLabel.text = self.date
        self.targetLabel.text = self.targetStr
        self.scoreLabel.text = "\(self.score!) %"
        if self.alarmOn {
            self.reminderButton.setImage(UIImage(named: "alarmOn"), for: .normal)
        } else {
            self.reminderButton.setImage(UIImage(named: "alarmOff"), for: .normal)
        }
        
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

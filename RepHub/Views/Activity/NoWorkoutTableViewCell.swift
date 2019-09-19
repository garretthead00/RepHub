//
//  NoWorkoutTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/19/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class NoWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("no workout awake")
        self.button.addTarget(self, action: #selector(startWorkout), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func startWorkout(){
        print("Start Workout...")
    }

}

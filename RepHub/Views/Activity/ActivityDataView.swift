//
//  ActivityDataView.swift
//  RepHub
//
//  Created by Garrett Head on 1/25/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class ActivityDataView: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!
    
    var data : (String, Double, String)? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.text = ""
        self.value.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateView(){
        if let data = self.data {
            self.icon.image = UIImage(named: data.0)
            self.label.text = "\(data.0)"
            self.value.text = "\(Int(data.1)) \(data.2)"
        }
    }

}

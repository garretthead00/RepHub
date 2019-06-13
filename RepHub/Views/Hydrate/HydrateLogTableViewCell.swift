//
//  HydrateLogTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 7/23/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class HydrateLogTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var name : String? {
        didSet {
            self.updateView()
        }
    }
    var quantity : Int? {
        didSet {
            self.updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.text = ""
        self.quantityLabel.text = ""
    }
    
    private func updateView(){
        if let logName = self.name {
            self.nameLabel.text = logName
            self.drinkImageView.image = UIImage(named: logName)
        }
        if let logQuantity = self.quantity {
            self.quantityLabel.text = "\(logQuantity) oz"
        }
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

}

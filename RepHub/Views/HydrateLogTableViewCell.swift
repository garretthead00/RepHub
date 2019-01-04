//
//  HydrateLogTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 7/23/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class HydrateLogTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkPhoto: UIImageView!
    @IBOutlet weak var logLabel: UILabel!
    
    var log : HydrateLog? {
        didSet {
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        logLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateView(){
        let ozString = String(describing: self.log?.oz ?? 0)
        let typeString = String(describing: self.log?.type ?? "")
        self.logLabel.text = "drank \(ozString) oz of \(typeString)"
        drinkPhoto.image = UIImage(named: typeString)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}

//
//  DrinkCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 6/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol DrinkDelegate {
    func selectedDrink(drink: String)
}

class DrinkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var delegate : DrinkDelegate?
    var drink : String? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.text = ""
        self.imageView.image = nil
    }
    
    private func updateView(){
        if let drink = self.drink {
            self.label.text = drink
            self.imageView.image = UIImage(named: drink)
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let drink = self.drink {
             self.delegate?.selectedDrink(drink: drink)
        }
       
    }
    
}

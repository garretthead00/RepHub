//
//  ExerciseModalityFilterCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 4/15/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol SetModalityFilterProtocol {
    func setModality(modality: String)
}

class ExerciseModalityFilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    var delegate : SetModalityFilterProtocol?
    var modality : String? {
        didSet {
            updateView()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.contentView.backgroundColor = UIColor.green
            }
            else {
                self.contentView.backgroundColor = UIColor.darkGray
            }
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.text = ""
    }
    
    private func updateView() {
        self.label.text = modality!
    }
    

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.setModality(modality: self.label.text!)
    }
    
    
}

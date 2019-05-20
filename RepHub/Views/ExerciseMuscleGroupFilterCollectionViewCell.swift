//
//  ExerciseMuscleGroupFilterCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 5/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol SetMuscleGroupFilterProtocol {
    func setMuscleGroup(muscleGroup: String)
}

class ExerciseMuscleGroupFilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var delegate : SetMuscleGroupFilterProtocol?
    var muscleGroup : String? {
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
        self.label.text = muscleGroup!
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.setMuscleGroup(muscleGroup: self.label.text!)
    }
    
}

//
//  ActiveExerciseTargetCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 3/2/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ActiveExerciseTargetSetDelegate {
    func addExerciseLog(forSet: Int)
}


class ActiveExerciseTargetCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var setTextField: UITextField!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var metricTypeTextField: UITextField!
    
    var delegate : ActiveExerciseTargetSetDelegate?
    var exercise : WorkoutExercise? {
        didSet {
            updateView()
        }
    }
    var index : Int?
    var logs : [ExerciseLog]? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTextField.text = ""
        self.setTextField.placeholder = "#"
        self.metricTypeTextField.text = ""
        self.metricTypeTextField.placeholder = "lbs"
        self.targetLabel.text = "#"
    }
    
    private func updateView() {
        self.setTextField.layer.cornerRadius = 15.0
        self.setTextField.layer.borderWidth = 1.0

        self.metricTypeTextField.layer.cornerRadius = 15.0
        self.metricTypeTextField.layer.borderWidth = 1.0

        
        
        
        if let index = self.index, let metricType = self.exercise?.metricType, let target = self.exercise?.target, let unit = self.exercise?.metricUnit {
            if self.logs != nil && self.logs!.indices.contains(index) {
                let value = self.logs![index].value!
                let weight = Int(self.logs![index].weightLB!)
                if metricType == "Time" {
                    self.setTextField.text = "\(index)"
                    self.metricTypeTextField.text = "\(value) \(unit)"
                    self.targetLabel.text = ""
                } else if metricType == "Distance" {
                    self.setTextField.text = "\(index)"
                    self.metricTypeTextField.text = "\(value) \(unit)"
                    self.targetLabel.text = ""
                } else {
                    self.setTextField.text = "\(index)"
                    self.metricTypeTextField.text = "\(weight) \(unit)"
                    self.targetLabel.text = "\(value)"
                }
                
                if let score = self.logs![index].score {
                    if score > 75.0 {
                        self.setTextField.layer.borderColor = UIColor.clear.cgColor
                        self.setTextField.layer.backgroundColor = UIColor.Theme.seaFoam.cgColor
                        self.metricTypeTextField.layer.borderColor = UIColor.clear.cgColor
                        self.metricTypeTextField.layer.backgroundColor = UIColor.Theme.seaFoam.cgColor
                    } else if score <= 75.0 && score > 50.0 {
                        self.setTextField.layer.borderColor = UIColor.clear.cgColor
                        self.setTextField.layer.backgroundColor = UIColor.Theme.banana.cgColor
                        self.metricTypeTextField.layer.borderColor = UIColor.clear.cgColor
                        self.metricTypeTextField.layer.backgroundColor = UIColor.Theme.banana.cgColor
                    } else if score <= 50.0 && score > 25.0 {
                        self.setTextField.layer.borderColor = UIColor.clear.cgColor
                        self.setTextField.layer.backgroundColor = UIColor.Theme.tangarine.cgColor
                        self.metricTypeTextField.layer.borderColor = UIColor.clear.cgColor
                        self.metricTypeTextField.layer.backgroundColor = UIColor.Theme.tangarine.cgColor
                    } else {
                        self.setTextField.layer.borderColor = UIColor.clear.cgColor
                        self.setTextField.layer.backgroundColor = UIColor.Theme.salmon.cgColor
                        self.metricTypeTextField.layer.borderColor = UIColor.clear.cgColor
                        self.metricTypeTextField.layer.backgroundColor = UIColor.Theme.salmon.cgColor
                    }
                } else {
                    self.setTextField.layer.borderColor = UIColor.darkGray.cgColor
                    self.setTextField.layer.backgroundColor = UIColor.clear.cgColor
                    self.metricTypeTextField.layer.borderColor = UIColor.darkGray.cgColor
                    self.metricTypeTextField.layer.backgroundColor = UIColor.clear.cgColor
                }
                
            } else {
                if metricType == "Time" {
                    self.setTextField.text = "\(index)"
                    self.metricTypeTextField.text = "\(target) \(unit)"
                    self.targetLabel.text = ""
                } else if metricType == "Distance" {
                    self.setTextField.text = "\(index)"
                    self.metricTypeTextField.text = "\(target) \(unit)"
                    self.targetLabel.text = ""
                } else {
                    self.setTextField.text = "\(index)"
                    self.metricTypeTextField.text = "\(unit)"
                    self.targetLabel.text = "\(target)"
                }
                self.setTextField.layer.borderColor = UIColor.darkGray.cgColor
                self.setTextField.layer.backgroundColor = UIColor.clear.cgColor
                self.metricTypeTextField.layer.borderColor = UIColor.darkGray.cgColor
                self.metricTypeTextField.layer.backgroundColor = UIColor.clear.cgColor
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.addExerciseLog(forSet: self.index!)
    }
    
}

extension UIColor {
    struct MyTheme {
        static var firstColor: UIColor  { return UIColor(red: 1, green: 0, blue: 0, alpha: 1) }
        static var secondColor: UIColor { return UIColor(red: 0, green: 1, blue: 0, alpha: 1) }
    }
}

//
//  HydrateDailyTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 7/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol HydrateDailiesCellDelegate {
    func addHydrateLog()
}

class HydrateDailyTableViewCell: UITableViewCell {

    @IBOutlet weak var dailyGoalImageView: UIImageView!
    @IBOutlet weak var hydrationGoalPercentCompleteLabel: UILabel!
    @IBOutlet weak var hydrationDailyTotalLabel: UILabel!
    @IBOutlet weak var editGoalLabel: UILabel!
    @IBOutlet weak var editGoalTextField: UITextField!
    var delegate : HydrateDailiesCellDelegate?
    var addLogButton = UIButton(type:.roundedRect)
    
    var dailies : HydrateDailies? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if !self.isEditing {
            //let button = UIButton(type:.roundedRect)
            addLogButton.setTitle("+", for: .normal)
            addLogButton.titleLabel?.font =  UIFont.systemFont(ofSize: 24)
            addLogButton.sizeToFit()
            addLogButton.addTarget(self, action: #selector(addHydrationLog(_:)), for: .touchUpInside)
            self.accessoryView = addLogButton
            editGoalLabel.isHidden = true
            editGoalTextField.isHidden = true
            hydrationDailyTotalLabel.isHidden = false
            hydrationGoalPercentCompleteLabel.isHidden = false
            }
        else {
            editGoalLabel.isHidden = false
            editGoalTextField.isHidden = false
            hydrationDailyTotalLabel.isHidden = true
            hydrationGoalPercentCompleteLabel.isHidden = true
            print("isEditing")
        }

        
    }
    
    func updateView(){
        
        var intakeString : String!
        var percentCompleteString : String?
        if let intake = self.dailies?.intake, intake > 0 , let goal = self.dailies?.goal  {
            let percentComplete = intake / goal * 100
            percentCompleteString = String(describing: percentComplete )
            intakeString = String(describing: intake )

        } else {
            intakeString = "0"
            percentCompleteString = "0"
        }
        let goalString = String(describing: self.dailies?.goal ?? 0)
        self.hydrationGoalPercentCompleteLabel.text = "\(percentCompleteString ?? "0") %"
        self.hydrationDailyTotalLabel.text = "\(intakeString ?? "0") / \(goalString) oz"
        self.dailyGoalImageView.image = UIImage(named: "Water")

   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addHydrationLog(_ sender: Any) {
        self.delegate?.addHydrateLog()
    }
    

}



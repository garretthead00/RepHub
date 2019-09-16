//
//  HydrateReminderTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 7/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit


class HydrateReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var reminderLabel: UILabel!
    let enableReminderSwitch = UISwitch(frame: .zero)
    
    var settings : HydrateSettings? {
        didSet {
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if !self.isEditing {
            //here is programatically switch make to the table view
            //let switchView = UISwitch(frame: .zero)
            enableReminderSwitch.setOn(false, animated: true)
            enableReminderSwitch.tag = 0 // for detect which row switch Changed
            enableReminderSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            self.accessoryView = enableReminderSwitch
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateView(){
//        let frequencyString = String(describing: settings?.frequency ?? 0)
//        self.reminderLabel.text = "Every \(frequencyString) \(settings?.interval ?? "")"
//        if let isOn = self.settings?.isReminderEnabled {
//            self.enableReminderSwitch.isOn = isOn
//        }
    }
    @objc func switchChanged(_ sender : UISwitch!){
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        //API.Hydrate.updateHydrationReminder(withValue: sender.isOn)
    }

}

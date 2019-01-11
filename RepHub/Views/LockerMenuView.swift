//
//  LockerMenuView.swift
//  RepHub
//
//  Created by Garrett Head on 1/10/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
protocol LockerMenuViewDelegate {
    func goTo(identifier: String)
}

class LockerMenuView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private var menuOptions = ["Activity","Messenger","Saved","Following","Followers"]
    private var imgNames = ["ChargeIcon", "message", "star_filled_green", "user-group", "user-group"]
    
    var delegate : LockerMenuViewDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LockerMenuTableViewCell", for: indexPath) as! LockerMenuTableViewCell
        cell.menuOptionLabel.text = menuOptions[indexPath.row]
        cell.menuOptionImageView.image = UIImage(named: imgNames[indexPath.row])
        //cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected option: \(menuOptions[indexPath.row])")
        //self.menudelegate?.goTo(identifier: menuOptions[indexPath.row])
        delegate?.goTo(identifier: menuOptions[indexPath.row])
        
    }
    


}



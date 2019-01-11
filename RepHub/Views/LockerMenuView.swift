//
//  LockerMenuView.swift
//  RepHub
//
//  Created by Garrett Head on 1/10/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol LockerMenuViewDelegate {
    func goTo(withIdentifier identifier: String)
}

class LockerMenuView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private var menuOptions = ["Activity","Messenger","Saved","Following","Followers"]
    private var imgNames = ["ChargeIcon", "message", "star_filled_green", "user-group", "user-group"]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LockerMenuTableViewCell", for: indexPath) as! LockerMenuTableViewCell
        cell.menuOptionLabel.text = menuOptions[indexPath.row]
        cell.menuOptionImageView.image = UIImage(named: imgNames[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    

}


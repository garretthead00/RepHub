//
//  BlockedUserTableViewCell.swift
//  RepHub
//
//  Created by Garrett on 1/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol BlockedUserCellDelegate {
    func gotoUserLockerVC(userId: String?)
}

class BlockedUserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var blockedUserButton: UIButton!
    
    
    var delegate : BlockedUserCellDelegate?
    
    var user: RepHubUser? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.usernameLabel_TouchUpInside))
        usernameLabel.addGestureRecognizer(tapGesture)
        usernameLabel.isUserInteractionEnabled = true
    }
    
    @objc private func usernameLabel_TouchUpInside() {
        if let id = user?.uid {
            delegate?.gotoUserLockerVC(userId: id)
        }
    }
    
    private func updateView() {
        self.usernameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImageView.sd_setImage(with: photoUrl)
        }
        
        if user!.isBlocked! {
            self.configureUnblockButton()
        } else {
            self.configureBlockButton()
        }
        
    }
    
    func configureBlockButton() {
        self.blockedUserButton.backgroundColor = UIColor(red: 8/255, green: 129/255, blue: 194/255, alpha: 1)
        self.blockedUserButton.setTitle("Block", for: UIControl.State.normal)
        self.blockedUserButton.addTarget(self, action: #selector(self.blockUser), for: UIControl.Event.touchUpInside)
    }
    
    func configureUnblockButton() {
        self.blockedUserButton.backgroundColor = UIColor.lightGray
        self.blockedUserButton.setTitle("Blocked", for: UIControl.State.normal)
        self.blockedUserButton.addTarget(self, action: #selector(self.unblockUser), for: UIControl.Event.touchUpInside)
    }
    
    
    @objc private func blockUser(){
        if self.user!.isBlocked! {
            API.Block.blockUser(withId: self.user!.uid!)
            self.configureUnblockButton()
            self.user!.isBlocked! = true
        }
    }
    
    @objc private func unblockUser() {
        if self.user!.isBlocked! {
            API.Block.blockUser(withId: self.user!.uid!)
            self.configureBlockButton()
            self.user!.isBlocked! = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}

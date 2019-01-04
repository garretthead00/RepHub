//
//  DiscoverUserTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 6/25/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol DiscoverUserCellDelegate {
    func gotoUserLockerVC(userId: String?)
}

class DiscoverUserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followUserButton: UIButton!
    
    var delegate : DiscoverUserCellDelegate?

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
        
        if user!.isFollowing! {
            self.configureUnfollowButton()
        } else {
            self.configureFollowButton()
        }
        
    }
    
    func configureFollowButton() {
        self.followUserButton.backgroundColor = UIColor(red: 8/255, green: 129/255, blue: 194/255, alpha: 1)
        self.followUserButton.setTitle("Follow", for: UIControl.State.normal)
        followUserButton.addTarget(self, action: #selector(self.followUser), for: UIControl.Event.touchUpInside)
    }
    
    func configureUnfollowButton() {
        self.followUserButton.backgroundColor = UIColor.lightGray
        self.followUserButton.setTitle("Following", for: UIControl.State.normal)
        followUserButton.addTarget(self, action: #selector(self.unfollowUser), for: UIControl.Event.touchUpInside)
    }
    
    
    @objc private func followUser() {
        if !user!.isFollowing! {
            API.Follow.followAction(withUser: self.user!.uid!)
            self.configureUnfollowButton()
            self.user!.isFollowing! = true
        }
    }
    
    @objc private func unfollowUser() {
        if self.user!.isFollowing! {
            API.Follow.unFollowAction(withUser: self.user!.uid!)
            self.configureFollowButton()
            self.user!.isFollowing! = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}

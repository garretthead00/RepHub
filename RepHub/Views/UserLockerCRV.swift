//
//  UserLockerCRV.swift
//  RepHub
//
//  Created by Garrett on 1/15/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//


import UIKit

class UserLockerCRV: UICollectionReusableView {
    
    @IBOutlet weak var repCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var user: RepHubUser? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clear()
    }
    
    func updateView(){
        self.bioLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profilePhotoImageView.sd_setImage(with: photoUrl, completed: nil)
        }
        
        API.RepHubUser.fetchTotalRepCount(userId: user!.uid!, completion: {
            count in
            self.repCountLabel.text = "\(count)"
        })
        API.Follow.fetchFollowerCount(userId: user!.uid!, completion: {
            count in
            self.followerCountLabel.text = "\(count)"
        })
        API.Follow.fetchFollowingCount(userId: user!.uid!, completion: {
            count in
            self.followingCountLabel.text = "\(count)"
        })
        self.followButton.titleLabel?.text = ""
        if user!.isFollowing! {
            self.followButton.setTitle("unfollow", for: .normal)
            self.followButton.titleLabel?.numberOfLines = 0
            self.followButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.followButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            self.followButton.setTitle("follow", for: .normal)
            self.followButton.titleLabel?.numberOfLines = 0
            self.followButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.followButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        }

    }
    
    private func clear(){
        self.repCountLabel.text = ""
        self.followerCountLabel.text = ""
        self.followingCountLabel.text = ""
        self.bioLabel.text = ""
        
    }
    
    @IBAction func followButton_TouchUpInside(_ sender: Any) {
        if !user!.isFollowing! {
            API.Follow.followAction(withUser: user!.uid!)
            user!.isFollowing! = true
            self.updateView()
        } else {
            API.Follow.unFollowAction(withUser: self.user!.uid!)
            self.user!.isFollowing! = false
            self.updateView()
        }
    }
}

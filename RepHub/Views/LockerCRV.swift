//
//  CollectionReusableView.swift
//  RepHub
//
//  Created by Garrett Head on 6/22/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class LockerCRV: UICollectionReusableView {
    
    @IBOutlet weak var repCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    
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
    }
    
    private func clear(){
        self.repCountLabel.text = ""
        self.followerCountLabel.text = ""
        self.followingCountLabel.text = ""
        self.bioLabel.text = ""
        
    }
    
}

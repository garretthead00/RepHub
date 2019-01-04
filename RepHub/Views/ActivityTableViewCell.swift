//
//  ActivityTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 7/7/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol ActivityCellDelegate {
    func goToDetailPostTVC(postId: String)
    func goToUserLockerVC(userId: String)
    func goToCommentVC(postId: String)
}

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    var delegate : ActivityCellDelegate?
    var notification: Notification? {
        didSet {
            updateView()
        }
    }
    var user: RepHubUser? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView(){
        switch  notification!.type! {
        case "feed":
            descriptionLabel.text = "shared a new post"
            let postId = notification!.objectId!
            API.Post.observePost(withId: postId, completion: { post in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.postImageView.sd_setImage(with: photoUrl)
                }
            })
        case "rep":
            descriptionLabel.text = "repped your post"
            
            let objectId = notification!.objectId!
            API.Post.observePost(withId: objectId, completion: { (post) in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.postImageView.sd_setImage(with: photoUrl)
                    
                }
            })
        case "comment":
            descriptionLabel.text = "commented on your post"
            let objectId = notification!.objectId!
            API.Post.observePost(withId: objectId, completion: { (post) in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.postImageView.sd_setImage(with: photoUrl)
                }
            })
            
        case "follow":
            descriptionLabel.text = "started following you"
            
            let objectId = notification!.objectId!
            API.Post.observePost(withId: objectId, completion: { (post) in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.postImageView.sd_setImage(with: photoUrl)
                    
                }
            })
        default:
            descriptionLabel.text = ""
        }
        
        self.timestampLabel.text = ""
        if let timestamp = notification?.timestamp {
            let timeText = getTimeLabel(timestamp: timestamp)
            self.timestampLabel.text = timeText
        }
    }
    
    func setupUserInfo(){
        self.usernameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImageView.sd_setImage(with: photoUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.usernameLabel.text = ""
        self.descriptionLabel.text = ""
        let activityCellTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cell_TouchUpInside))
        addGestureRecognizer(activityCellTapGesture)
        isUserInteractionEnabled = true

    }
    
    @objc private func cell_TouchUpInside() {
        if let id = notification?.objectId {
            if notification!.type! == "follow" {
                delegate?.goToUserLockerVC(userId: id)
            } else if notification!.type! == "comment" {
                delegate?.goToCommentVC(postId: id)
            } else {
                delegate?.goToDetailPostTVC(postId: id)
            }
            
        }
        
    }
    


    private func getTimeLabel (timestamp: Int) -> String {
        let timeStampDate = Date(timeIntervalSince1970: Double(timestamp))
        let now = Date()
        let components = Set<Calendar.Component>([.second,.minute,.hour,.day,.weekOfMonth])
        let diff = Calendar.current.dateComponents(components, from: timeStampDate, to: now)
        var timeText = ""
        if diff.second! <= 0 {
            timeText = "Now"
        }
        else if diff.second! > 0 && diff.minute! == 0 {
            timeText = "\(diff.second!)s"
        }
        else if diff.minute! > 0 && diff.hour! == 0 {
            timeText = "\(diff.minute!)m"
        }
        else if diff.hour! > 0 && diff.day! == 0 {
            timeText = "\(diff.hour!)h"
        }
        else if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = "\(diff.day!)d"
        }
        else {
            timeText = "\(diff.weekOfMonth!)w"
        }
        return timeText
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

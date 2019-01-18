//
//  FeedTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 6/15/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit
import AVFoundation
import KILabel

protocol FeedCellDelegate {
    func goToCommentsVC(postId: String)
    func goToUserLockerVC(userId: String)
    func goToHashTagVC(hashtag: String)
    func toggleMenu(postId: String, userId: String)
}


class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: KILabel!
    @IBOutlet weak var repCountLabel: UILabel!
    @IBOutlet weak var repButton: UIButton!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate : FeedCellDelegate?
    var player: AVPlayer?
    var playerLayer : AVPlayerLayer?
    var isMuted = true
    var post: Post? {
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
        self.captionLabel.text = post?.caption!
        self.captionLabel.hashtagLinkTapHandler = { label, string, range in
            let hashtag = String(string.dropFirst())
            self.delegate?.goToHashTagVC(hashtag: hashtag)
            
        }
        self.captionLabel.userHandleLinkTapHandler = { label, string, range in
            let mention = String(string.dropFirst())
            API.RepHubUser.observeUserByName(username: mention.lowercased(), completion: {
                user in
                self.delegate?.goToUserLockerVC(userId: user.uid!)
            })
        }
        if let ratio = post?.ratio {
            imageHeightConstraint.constant = UIScreen.main.bounds.width / ratio
            layoutIfNeeded()
        }
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            self.postImageView.sd_setImage(with: photoUrl)
        }
        if let videoUrlString = post?.videoUrl, let videoUrl = URL(string: videoUrlString) {
            self.volumeView.isHidden = false
            player = AVPlayer(url: videoUrl)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = postImageView.frame
            playerLayer?.frame.size.width = UIScreen.main.bounds.width
            playerLayer?.frame.size.height = UIScreen.main.bounds.width / post!.ratio!
            self.contentView.layer.addSublayer(playerLayer!)
            self.volumeView.layer.zPosition = 1
            player?.play()
            player?.isMuted = self.isMuted
        }
        self.timestampLabel.text = ""
        if let timestamp = post?.timestamp {
            let timeText = getTimeLabel(timestamp: timestamp)
            self.timestampLabel.text = timeText
        }
        self.updateRep(post: self.post!)
        self.updateSaved(post: self.post!)
    }
    
    func updateRep(post: Post){
        let imageName = post.reps == nil || !post.isRepped! ? "rep_blank" : "rep"
        repButton.setImage(UIImage(named: imageName), for: .normal)
        self.updateRepCount(post: post)
    }
    
    func updateSaved(post: Post){
        let imageName = post.saves == nil || !post.isSaved! ? "star_green" : "star_filled_green"
        saveButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func updateRepCount(post: Post) {
        var repCountString : String?
        switch post.repCount {
        case nil:
            repCountString = "Be the first to rep this."
        case 0:
            repCountString = "Be the first to rep this."
        case 1:
            repCountString = "\(post.repCount!) rep"
        default:
            repCountString = "\(post.repCount!) reps"
        }
        self.repCountLabel.text = repCountString
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
        // Initialization code
        self.usernameLabel.text = ""
        self.captionLabel.text = ""
        let usernameLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.usernameLabel_TouchUpInside))
        usernameLabel.addGestureRecognizer(usernameLabelTapGesture)
        usernameLabel.isUserInteractionEnabled = true
    }
    
    @objc private func usernameLabel_TouchUpInside() {
        if let id = user?.uid {
            delegate?.goToUserLockerVC(userId: id)
        }
    }
            

    override func prepareForReuse() {
        super.prepareForReuse()
        self.volumeView.isHidden = true
        profileImageView.image = nil
        playerLayer?.removeFromSuperlayer()
        player?.pause()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func moreButton_TouchUpInside(_ sender: Any) {
        delegate?.toggleMenu(postId: self.post!.id!, userId: self.user!.uid!)
    }
    @IBAction func commentButton_touchUpInside(_ sender: Any) {
        if let id = post?.id {
            self.delegate?.goToCommentsVC(postId: id)
        }
    }

    @IBAction func repButton_touchUpInside(_ sender: Any) {
        API.Post.handleReps(postId: post!.id!, onSuccess: {
            post in
            self.updateRep(post: post)
            self.post?.reps = post.reps
            self.post?.isRepped = post.isRepped
            self.post?.repCount = post.repCount
            
            if self.post?.reps != nil {
                let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
                
                if let isRepped = post.isRepped {
                    if isRepped {
                        let newNotificationReference = API.Notification.NOTIFICATION_DB_REF.child(post.uid!).child("\(post.id!)-\(API.RepHubUser.CURRENT_USER!.uid)")
                        newNotificationReference.setValue(["from": API.RepHubUser.CURRENT_USER!.uid, "objectId": post.id!, "type": "rep", "timestamp": timestamp])
                    } else {
                        let newNotificationReference = API.Notification.NOTIFICATION_DB_REF.child(post.uid!).child("\(post.id!)-\(API.RepHubUser.CURRENT_USER!.uid)")
                        newNotificationReference.removeValue()
                    }
                }
                
            }
        }, onError: {
            errorMessage in
            ProgressHUD.showError(errorMessage)
            
        })
        
    }
    
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        
        if self.post?.isSaved ?? false {
            print("isSaved -- remove from saved")
            if let id = self.post?.id {
           
                API.Post.removeSaved(withPostId: id, completion: {
                    post in
                    self.post?.isSaved = post.isSaved
                    print("self.post.isSaved: \(self.post?.isSaved) --- post.isSaved: \(post.isSaved)")
                    //self.updateSaved(post: self.post!)
                    self.post = post
                    self.updateView()
                })
            }
        } else {
            print("save Post -- add to saved")
            if let id = self.post?.id {
                API.Post.savePost(withPostId: id, completion: {
                    post in
                    self.post?.isSaved = post.isSaved
                    print("self.post.isSaved: \(self.post?.isSaved) --- post.isSaved: \(post.isSaved)")
                    //self.updateSaved(post: self.post!)
                    self.post = post
                    self.updateView()
                })
            }
        }
        

        
    }
    
    
    @IBAction func volumeButton_TouchUpInside(_ sender: UIButton) {
        if isMuted {
            isMuted = !isMuted
            volumeButton.setImage(UIImage(named: "volume"), for: .normal)
        } else {
            isMuted = !isMuted
            volumeButton.setImage(UIImage(named: "mute"), for: .normal)
        }
        player?.isMuted = self.isMuted
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
            timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
        }
        else if diff.minute! > 0 && diff.hour! == 0 {
            timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
        }
        else if diff.hour! > 0 && diff.day! == 0 {
            timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
        }
        else if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
        }
        else {
            timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
        }
        return timeText
    }
    

}





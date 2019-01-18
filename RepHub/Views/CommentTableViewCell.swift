//
//  CommentTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 6/18/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit
import KILabel

protocol CommentCellDelegate {
    func goToUserLockerVC(userId: String)
    func goToHashTagVC(hashtag: String)
    func reportComment(withId: String, userId: String)
}

class CommentTableViewCell: UITableViewCell {

    // View
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: KILabel!
    @IBOutlet weak var reportButton: UIButton!
    
    var delegate : CommentCellDelegate?
    var comment: Comment? {
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
       self.commentLabel.text = comment?.commentText
        self.commentLabel.hashtagLinkTapHandler = { label, string, range in
            let hashtag = String(string.dropFirst())
            self.delegate?.goToHashTagVC(hashtag: hashtag)
            
        }
        self.commentLabel.userHandleLinkTapHandler = { label, string, range in
            let mention = String(string.dropFirst())
            API.RepHubUser.observeUserByName(username: mention.lowercased(), completion: {
                user in
                self.delegate?.goToUserLockerVC(userId: user.uid!)
            })
        }
    }
    
    func setupUserInfo(){
        self.nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImageView.sd_setImage(with: photoUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGesture)
        nameLabel.isUserInteractionEnabled = true
        let reportButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.reportButton_TouchUpSinde))
        reportButton.addGestureRecognizer(reportButtonTapGesture)
        reportButton.isUserInteractionEnabled = true
    }
    
    @objc private func reportButton_TouchUpSinde(){
        if let id = user?.uid {
            delegate?.reportComment(withId: self.comment!.commentId!, userId: id)
        }
    }
    @objc private func nameLabel_TouchUpInside() {
        if let id = user?.uid {
            delegate?.goToUserLockerVC(userId: id)
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "Camera")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

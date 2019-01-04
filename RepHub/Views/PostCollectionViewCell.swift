//
//  UserPostCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 6/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol PostCellDelegate {
    func goToDetailPostTVC(postId: String)
}


class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate : PostCellDelegate?
    var post : Post? {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            self.imageView.sd_setImage(with: photoUrl)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageView_TouchUpInside))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    
    @objc private func imageView_TouchUpInside() {
        if let id = post?.id {
            delegate?.goToDetailPostTVC(postId: id)
        }
    }
}

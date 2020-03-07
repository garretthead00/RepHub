//
//  CreateDrinkImageView.swift
//  RepHub
//
//  Created by Garrett Head on 1/5/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class CreateDrinkImageView: UITableViewCell {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    var delegate : CreateFoodDelegate?
    
    var upload : UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cameraButton.contentHorizontalAlignment = .fill
        cameraButton.contentVerticalAlignment = .fill
        cameraButton.imageView?.contentMode = .scaleAspectFit
        galleryButton.contentHorizontalAlignment = .fill
        galleryButton.contentVerticalAlignment = .fill
        galleryButton.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}




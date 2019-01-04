//
//  WalkthroughViewController.swift
//  RepHub
//
//  Created by Garrett Head on 7/9/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    var index = 0
    var imageFileName = ""
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = "\(content) at index: \(index)"
        backgroundImageView.image = UIImage(named: imageFileName)
        pageControl.currentPage = index
        switch index {
        case 0:
            self.prevButton.isHidden = true
            self.nextButton.setTitle("Next", for: .normal)
        case 1:
            self.prevButton.isHidden = false
            self.prevButton.setTitle("Prev", for: .normal)
            self.nextButton.setTitle("Next", for: .normal)
        case 2 :
            self.prevButton.isHidden = false
            self.prevButton.setTitle("Prev", for: .normal)
            self.nextButton.setTitle("Done", for: .normal)
        default:
            break
        }
    }
    
    
    @IBAction func nextButton_TouchUpInside(_ sender: Any) {
        switch index {
        case 0...1:
            let pageVC = parent as! WalkthroughPageViewController
            pageVC.next(index: index)
        case 2:
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "hasViewedWalkthrough")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    

    @IBAction func prevButton_TouchUpInside(_ sender: Any) {
        switch index {
        case 1...2:
            let pageVC = parent as! WalkthroughPageViewController
            pageVC.prev(index: index)
        default:
            break
        }
    }
    

}

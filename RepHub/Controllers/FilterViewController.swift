//
//  FilterViewController.swift
//  RepHub
//
//  Created by Garrett Head on 7/4/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func updatePhoto(image: UIImage)
}

class FilterViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    var selectedImage : UIImage!
    var delegate: FilterViewControllerDelegate?
    private let filterOptions = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    let context =  CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = selectedImage
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton_TouchUpInside))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton_TouchUpInside))
    }


    
    @objc private func doneButton_TouchUpInside(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        //delegate?.updatePhoto(image: self.imageView.image!)
//        dismiss(animated: true, completion: {
//            self.performSegue(withIdentifier: "PostSettings", sender: nil)
//        })
        self.performSegue(withIdentifier: "PostSettings", sender: nil)

    }
    @objc private func cancelButton_TouchUpInside(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / selectedImage.size.width
        let newHeight = selectedImage.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        selectedImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostSettings" {
            let postSettingsTVC = segue.destination as! PostSettingsTableViewController
            postSettingsTVC.selectedImage = selectedImage
            
        }
    }
}

extension FilterViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCollectionViewCell
        let resizedImage = resizeImage(image: selectedImage, newWidth: 150)
        let ciImage = CIImage(image: resizedImage)
        let filter = CIFilter(name: filterOptions[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredImage, from: filteredImage.extent)
            cell.filteredImageView.image = UIImage(cgImage: result!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = CIImage(image: selectedImage)
        let filter = CIFilter(name: filterOptions[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredImage, from: filteredImage.extent)
            self.imageView.image = UIImage(cgImage: result!)
        }
    }
}

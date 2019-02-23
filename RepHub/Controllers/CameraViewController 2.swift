//
//  ThirdViewController.swift
//  TabApp
//
//  Created by Garrett Head on 2/21/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import ImagePicker

class CameraViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    private var selectedPhoto : UIImage?
    private var videoUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // present the imagepicker view on load.
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true,completion: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.handlePost()
    }
    
    private func handlePost(){
        if selectedPhoto !=  nil {
            self.shareButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.removeButton.isEnabled = true
            self.shareButton.isEnabled = true
            } else {
            self.shareButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
            self.removeButton.isEnabled = false
            self.shareButton.isEnabled = false
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    @IBAction func removePost_TouchUpInside(_ sender: Any) {
        self.clean()
        self.handlePost() 
    }
    
    private func clean() {
        self.caption.text = ""
        self.photo.image = UIImage(named: "CameraIcon")
        self.selectedPhoto = nil
    }
    
    @objc private func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image", "public.movie"]
        present(pickerController, animated: true, completion: nil)
    }

//    @IBAction func shareImage_TouchUpInside(_ sender: Any) {
//        view.endEditing(true)
//        ProgressHUD.show("Posting...", interaction: false)
//        if let photoImg = selectedPhoto, let imageData = photoImg.jpegData(compressionQuality: 1) {
//            let ratio = photoImg.size.width / photoImg.size.height
//            HelperService.uploadToServer(data: imageData, videoUrl: self.videoUrl, ratio: ratio, caption: caption.text, onSuccess: {
//                self.clean()
//                self.tabBarController?.selectedIndex = 0
//            })
//        }
//        else {
//            ProgressHUD.showError("Please select an image.")
//        }
//    }
    
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true,completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Filter" {
            let filterVC = segue.destination as! FilterViewController
            filterVC.selectedImage = self.selectedPhoto
            filterVC.delegate = self
        }
    }
    
    
}

extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        // if the user has selected a video
        if let videoUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            if let thumbnail = self.generateVideoThumbnail(videoUrl) {
                self.selectedPhoto = thumbnail
                self.photo.image = thumbnail
                self.videoUrl = videoUrl
            }

            dismiss(animated: true, completion: nil)
        }
        
        // if the user selected a photo and not a video
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedPhoto = image
            photo.image = image
            dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "Filter", sender: nil)
            })
        }
    }
    
    private func generateVideoThumbnail(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 6, timescale: 3), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print(error)
        }
        return nil
    }
}

extension CameraViewController : FilterViewControllerDelegate {
    func updatePhoto(image: UIImage) {
        self.photo.image = image
        self.selectedPhoto = image
    }
    
}

extension CameraViewController : ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {}
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        guard let image = images.first else {
            dismiss(animated: true, completion: nil)
            return
        }
        selectedPhoto = image
        photo.image = image
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "Filter", sender: nil)
        })
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        dismiss(animated: true, completion: nil)
        return
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

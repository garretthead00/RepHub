//
//  ImagePickerViewController.swift
//  RepHub
//
//  Created by Garrett Head on 1/31/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation

class ImagePickerViewController: UIViewController {
    

    private var videoUrl : URL?
    private var selectedPhoto : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.handlePost()
    }
    
    private func handlePost(){
//        if selectedPhoto !=  nil {
//            self.shareButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
//            self.removeButton.isEnabled = true
//            self.shareButton.isEnabled = true
//        } else {
//            self.shareButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
//            self.removeButton.isEnabled = false
//            self.shareButton.isEnabled = false
//        }
    }
    

    
    @IBAction func libraryButton_TouchUpInside(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func photoButton_TouchUpInside(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    @IBAction func videoButton_TouchUpInside(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = ["public.movie"]
            imagePickerController.cameraCaptureMode = .video
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Filter" {
            let filterVC = segue.destination as! FilterViewController
            filterVC.selectedImage = self.selectedPhoto
            filterVC.videoUrl = self.videoUrl
            filterVC.delegate = self
        }
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

extension ImagePickerViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let videoUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            if let thumbnail = self.generateVideoThumbnail(videoUrl) {
                print("video")
                self.videoUrl = videoUrl
                selectedPhoto = thumbnail
                dismiss(animated: true, completion: {
                    self.performSegue(withIdentifier: "Filter", sender: nil)
                })
            }

        }
        
        if let selectedProfileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            print("Camera/Library Image")
            self.videoUrl = nil
            selectedPhoto = selectedProfileImage
            dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "Filter", sender: nil)
            })
        }
    }
    
    private func generateVideoThumbnail(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 6, timescale: 3), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImagePickerViewController : FilterViewControllerDelegate {
    func updatePhoto(image: UIImage) {
        self.selectedPhoto = image
    }
    
}


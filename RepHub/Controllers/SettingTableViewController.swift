//
//  SettingTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/30/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol SettingsDelegate {
    func updateLocker()
}


class SettingTableViewController: UITableViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var selectedImage : UIImage!
    var delegate : SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        fetchCurrentUser()
    }


    private func fetchCurrentUser(){
        API.RepHubUser.observerCurrentUser(completion: {
            user in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            if let photoUrl = URL(string: user.profileImageUrl!){
                self.imageView.sd_setImage(with: photoUrl, completed: nil)
            }
        })
    }

    
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        if let profileImg = self.imageView.image, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            ProgressHUD.show("Updating...")
            AuthService.updateUserInfo(username: usernameTextField.text!, email: emailTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Updated Successfully!")
                self.delegate?.updateLocker()
            }, onError: {
                error in
                ProgressHUD.showError(error)
            })
        }
        
    }
    

    @IBAction func logoutButton_TouchUpInside(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Launch", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginVC, animated: true, completion: nil)
        }, onError: {
            errorMessage in
            ProgressHUD.showError(errorMessage)
        })
    }

    @IBAction func changePhoto_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
}

extension SettingTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // fires after an image has been selected from the Image Picker
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension SettingTableViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

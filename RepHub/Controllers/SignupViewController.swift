//
//  SignupViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/8/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var facebookSignUpButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var selectedImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleSignupControls()
    }

    private func styleSignupControls(){
        // customize controller textfields
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        usernameTextField.tintColor = UIColor.white
        usernameTextField.textColor = UIColor.white
        let userNameBottomLayer = CALayer()
        userNameBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        userNameBottomLayer.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0).cgColor
        usernameTextField.layer.masksToBounds = true
        usernameTextField.layer.addSublayer(userNameBottomLayer)
        
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        let emailBottomLayer = CALayer()
        emailBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        emailBottomLayer.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0).cgColor
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.addSublayer(emailBottomLayer)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        let passwordBottomLayer = CALayer()
        passwordBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.5)
        passwordBottomLayer.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0).cgColor
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.addSublayer(passwordBottomLayer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        registerButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
        registerButton.isEnabled = false
        validateTextFields()
     }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func validateTextFields() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }

    @objc private func textFieldDidChange(){
        // checks any of the textfields has input
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            registerButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
            registerButton.isEnabled = false
            return
        }
        registerButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        registerButton.isEnabled = true
    }
    
    @objc private func selectProfileImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func registerUserAccount(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Registering...", interaction: false)
        if let profileImg = selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            AuthService.registerUser(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                //ProgressHUD.showSuccess("Success!")
                self.performSegue(withIdentifier: "signin", sender: nil)
            }, onError: { (error) in
                ProgressHUD.showError(error!)
                print(error!)
            })
        }
        else {
            ProgressHUD.showError("Please select a profile image.")
        }
    }
    
}


extension SignupViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // fires after an image has been selected from the Image Picker
        if let selectedProfileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = selectedProfileImage
            profileImage.image = selectedProfileImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

//
//  LoginViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/8/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleLoginControls()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let defaults = UserDefaults.standard
        let hasViewedWalkthrough = defaults.bool(forKey: "hasViewedWalkthrough")
        if !hasViewedWalkthrough {
            if let pageVC = storyboard?.instantiateViewController(withIdentifier: "WalkthroughPageViewController") as? WalkthroughPageViewController {
                present(pageVC, animated: true, completion: nil)
            }
        }
        if API.RepHubUser.CURRENT_USER != nil {
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    
    private func styleLoginControls(){
        // customize controller textfields
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        let emailBottomLayer = CALayer()
        emailBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.5)
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
        loginButton.isEnabled = false
        validateTextFields()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func validateTextFields() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc private func textFieldDidChange(){
        // checks any of the textfields has input
        guard let email = self.emailTextField.text, !email.isEmpty, let password = self.passwordTextField.text, !password.isEmpty else {
            loginButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
            loginButton.isEnabled = false
            return
        }
        loginButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        loginButton.isEnabled = true
    }
    
    @IBAction func loginUser(_ sender: Any) {
        view.endEditing(false)
        ProgressHUD.show("Waiting...", interaction: false)
        AuthService.loginUser(email: self.emailTextField.text!, password: self.passwordTextField.text!, onSuccess: {
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "login", sender: nil)
        }, onError: { error in
            ProgressHUD.showError(error!)
        })
    }
}

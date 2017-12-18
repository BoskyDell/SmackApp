//
//  LoginVC.swift
//  Smack
//
//  Created by Kevin Keefe on 11/27/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // Outlets
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        spinner.isHidden = true
        
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceHolder])

        
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceHolder])
        
    }
    
    
    @IBAction func closedPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
        
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = usernameTxt.text , usernameTxt.text != "" else { return }
        guard let pass = passwordTxt.text , passwordTxt.text != "" else { return }
        
        print("LoginVC:LoginPressed:AuthService:loginUser: Attempting LoginUser \(email) PWD\(pass)\n")
        
        AuthService.instance.loginUser(email: email, password: pass) { (success) in
            if success {
                print("LoginVC:LoginPressed:AuthService:loginUser: Attempting LoginUser \(email) Call FindUserByEmail\n")
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        print("LoginVC:LoginPressed:AuthService:loginUser: Attempting LoginUser \(email) Success!\n")
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("LoginVC:LoginPressed:AuthService:loginUser: Attempting LoginUser \(email) Failed to find Email\n")
                    }
                })
            } else {
                print("LoginVC:LoginPressed:AuthService:loginUser: Attempting LoginUser \(email) Failed to login\n")
            }
        }
    }
    
    
    
}

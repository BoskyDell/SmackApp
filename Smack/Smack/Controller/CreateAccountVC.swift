//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Kevin Keefe on 11/29/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func createAccntPressed(_ sender: Any) {
        
        guard let email = emailTxt.text , emailTxt.text != "" else { return }
        
        guard let pass  = passTxt.text ,  passTxt.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                print("\(email) reistered User")
            }
        }
    }
   
    @IBAction func pickAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
    
    
    @IBAction func closedPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    

}

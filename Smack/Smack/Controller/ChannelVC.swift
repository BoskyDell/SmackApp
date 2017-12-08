//
//  ChannelVC.swift
//  Smack
//
//  Created by Kevin Keefe on 11/24/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
// Outlets
    @IBOutlet weak var userImg: CircleImage!
    
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }

    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
        }
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            let profile = RealProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
           performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    
}

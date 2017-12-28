//
//  RealProfileVC.swift
//  Smack
//
//  Created by Kevin Keefe on 12/8/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import UIKit

class RealProfileVC: UIViewController {

    // Outlets
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!

    @IBOutlet weak var updateProfileBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        print("RealProfileVC:SetupUserInfo: Entered")
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(RealProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateProfilePressed(_ sender: UIButton) {
        
        if AuthService.instance.isLoggedIn {
            let profile = UpdateProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
        
    }
    
    
}

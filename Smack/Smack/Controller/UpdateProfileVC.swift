//
//  UpdateProfileVC.swift
//  Smack
//
//  Created by Kevin Keefe on 12/27/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import UIKit

class UpdateProfileVC: UIViewController {

    // Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userIdNumber: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        print("UpdateUserProfileVC:SetupUserInfo: Entered")
        userName.text     = UserDataService.instance.name
        userEmail.text    = UserDataService.instance.email
        userIdNumber.text = "************"
        
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(UpdateProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }

    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func updateBtnPressed(_ sender: UIButton) {
        
        let newName  = userName.text
        let origName = UserDataService.instance.name
        let email    = UserDataService.instance.email
        let id       = UserDataService.instance.id
        let aName    = UserDataService.instance.avatarName
        let aColor   = UserDataService.instance.avatarColor
  
        print("UpdateUserProfileVC:updateBtnPressed: Entered")
        
        if newName == origName {
            debugPrint("UserProfileVC:updateBtnPressed -- requested UserName is same as current name")
        } else if newName == "" {
            debugPrint("UserProfileVC:updateBtnPressed -- requested UserName is emptyString")
        } else {
            debugPrint("UserProfileVC:updateBtnPressed -- Calling AuthServiceUpdateUSer email[\(email)] id[\(id)] newName[\(newName)]")
            AuthService.instance.updateUser(email: email, id: id, name: newName!) { (success) in
                if success {
                    UserDataService.instance.updateUserData(color: aColor, avatarName: aName, email: email, name: newName!)
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    debugPrint("UserProfileVC:updateBtnPressed:AuthServiceInstUpdateUser: FAILED")
                }
            }
        }
    }
}

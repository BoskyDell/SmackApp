//
//  UserDataService.swift
//  Smack
//
//  Created by Kevin Keefe on 12/6/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id          = ""
    public private(set) var email       = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName  = ""
    public private(set) var name        = ""
    
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String)  {
        self.id = id
        self.avatarName = avatarName
        self.avatarColor = color
        self.email = email
        self.name = name
        
    }
    
    func setAvatarName( avatarName: String) {
        self.avatarName = avatarName
    }
    
}

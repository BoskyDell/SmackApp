//
//  Contants.swift
//  Smack
//
//  Created by Kevin Keefe on 11/27/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constatns
let BASE_URL          = "https://macchatty.herokuapp.com/v1/"

let URL_REGISTER      = "\(BASE_URL)account/register"
let URL_LOGIN         = "\(BASE_URL)account/login"
let URL_USER_ADD      = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS  = "\(BASE_URL)channel"
let URL_GET_MESSAGES  = "\(BASE_URL)message/byChannel/"

// COlors
let smackPurplePlaceHolder = #colorLiteral(red: 0.3568627451, green: 0.6235294118, blue: 0.7960784314, alpha: 0.5191834332)

// Notification Constants
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name("channelSelected")



// Seques
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "UnwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// User Defaults
let TOKEN_KEY  = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


// HEADERS
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type" : "application/json; charset=utf-8"
]

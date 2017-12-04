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
let BASE_URL = "https://macchatty.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"


// Seques
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "UnwindToChannel"

// User Defaults
let TOKEN_KEY  = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


//
//  AuthService.swift
//  Smack
//
//  Created by Kevin Keefe on 12/4/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            var tokenString : String = defaults.value(forKey: TOKEN_KEY) as! String
            print("AuthService:GETAuthToken:Key\(TOKEN_KEY) Value\(tokenString)")
            return defaults.value(forKey: TOKEN_KEY) as! String
        }

        set {
            print("AuthService:SetAuthToken:Key\(TOKEN_KEY) Value(\newValue)")
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser (email: String, password: String, completion: @escaping CompletionHandler ) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        print("START AuthService:RegisterUser:Alamofire: Register User \(lowerCaseEmail)\n")
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                print("AuthService:RegisterUser:Alamofire: Registered User \(lowerCaseEmail)\n")
                completion(true)
            } else {
                completion(false)
                print("FAILED AuthService:RegisterUser:Alamofire: Registered User \(lowerCaseEmail)\n")
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    
    func loginUser ( email: String, password: String, completion: @escaping CompletionHandler ) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
    
        print("START AuthService:LoginUser:Alamofire: login User \(lowerCaseEmail) LoginURL \(URL_LOGIN) Header\(HEADER) \n")
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                
                // Original JSON Parsing
//                if let json = response.result.value as? Dictionary<String, Any> {
//                    if let email = json["user" ] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                

                // Swifty JSON method
                guard let data = response.data else {
                    print("AlamoFire AuthService:LoginUser:AlamofireRequest: Could not Parse response Data \n")
                    return
                }

                do {

                    let json = try JSON(data: data)

                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue

                    self.isLoggedIn = true
                    print("AlamoFire AuthService:LoginUser:AlamofireRequest: login User \(self.userEmail) Token \(self.authToken) Success\n")

                    completion(true)
                } catch let error as NSError {
                    print("Failed AlamoFire AuthService:LoginUser:AlamofireRequest: login User \(self.userEmail) ToKen \(self.authToken)\n")

                    completion(false)
                    debugPrint(error as Any)
                }
            } else {
                print("FAILED AlamoFire AuthService:LoginUser:Alamofire: login User \(lowerCaseEmail) ResultError is not NIL!\n")
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        print("Completed AuthService:LoginUser:Alamofire: login User \(lowerCaseEmail)\n")
    }
    
    func createUser( name: String, email : String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler ) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "name" : name,
            "avatarColor" : avatarColor,
            "avatarName"  : avatarName
        ]
        
        print("AuthService:CreateUser:Alamofire.Request URL\(URL_USER_ADD) Header\(BEARER_HEADER) AuthToken\(AuthService.instance.authToken) \n")
        
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {
                    print("AuthService:CreateUser:Alamofire.Request could not get response Data\n")
                    return}
                completion (self.setUserInfo(data: data))
                
            } else {
                completion(false)
                print("AuthService:CreateUser:Alamofire.Request result error not NIL\n")
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        print("AuthService:FindUserEmail:Alamofire.Request URL\(URL_USER_BY_EMAIL)\(userEmail) Header\(BEARER_HEADER) AuthToken\(AuthService.instance.authToken) \n")
        
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {
                    print("AuthService:FindUserEmail:Alamofire.Request URL\(URL_USER_BY_EMAIL)\(self.userEmail) could not parse response.data\n")
                    return
                }
                completion (self.setUserInfo(data: data))
            } else {
                print("AuthService:FindUserEmail:Alamofire.Request URL\(URL_USER_BY_EMAIL)\(self.userEmail) ResponseResultError not NIL FAILED!\n")
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func setUserInfo(data: Data) -> Bool {
        
        var retVal : Bool  = false
        do {
            let json = try JSON(data: data)
            let id         = json["_id"].stringValue
            let color      = json["avatarColor"].stringValue
            let avatarName = json["avatarName"].stringValue
            let name       = json["name"].stringValue
            let email      = json["email"].stringValue
        
            UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
            
            retVal = true
        } catch let error as NSError {
            debugPrint(error as Any)
        }
        
        return retVal
    }
}

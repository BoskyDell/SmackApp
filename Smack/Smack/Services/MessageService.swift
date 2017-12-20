//
//  MessageService.swift
//  Smack
//
//  Created by Kevin Keefe on 12/9/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    
    var selectedChannel : Channel?
    
    func findAllChannels (completion: @escaping CompletionHandler) {
        print("MessageService:FindAllChannels: Entered\n")
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            print("MessageService:FindAllChannels:AlomoFire.request completed\n")
            if response.result.error == nil {
                guard let data = response.data else {return}
                
                do {
                    // Swift 3 style
                    if let json = try JSON(data:data).array {
                        for item in json {
                            let name = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let id = item["_id"].stringValue
                            let channel = Channel(id: id, channelTitle: name, channelDescription: channelDescription)
                            self.channels.append(channel)
                            print("MessageService:FindAllChannels:NotifyChannelVC: Channel[\(channel)] APPENDED\n")
                        }
                    }
                    
                    print("MessageService:FindAllChannels:NotifyChannelVC: ChannelsLoaded\n")
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                    
                    // Swift 4 style
                    //  self.channels = try JSONDecoder().decode([Channel].self, from: data)
                    
                } catch let error {
                    completion(false)
                    debugPrint(error as Any)
                }
                
                // print("MessageService \(self.channels[0].channelTitle)")
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            print("MessageService:FindAllMessagesForChannels:AlomoFire.request completed\n")
            if response.result.error == nil {
                print("MessageService:FindAllMessagesForChannels:AlomoFire.request success\n")
                self.clearMessages()
                guard let data = response.data else {
                    print("MessageService:FindAllMessagesForChannels:AlomoFire.request BUT could not parse response dataq\n")
                    return
                }
                
                do {
                    if let json = try JSON(data:data).array {
                        for item in json {
                            let messageBody = item["messageBody"].stringValue
                            let userName    = item["userName"].stringValue
                            let channelId   = item["channelId"].stringValue
                            let userAvatar  = item["userAvatar"].stringValue
                            let userAvatorColor = item["userAvatorColor"].stringValue
                            let id          = item["_id"].stringValue
                            let timeStamp   = item["timeStamp"].stringValue
                            
                            let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatorColor: userAvatorColor, id: id, timeStamp: timeStamp)
                            self.messages.append(message)
                            print("MessageService:FindAllMessagesForChannels: Messsage ID[\(id)] APPENDED\n")
                        }

                        completion(true)
                    }
                    
                } catch let error {
                    print("MessageService:FindAllMessagesForChannels: Messsage failed to read JSON data\n")
                    completion(false)
                    debugPrint(error as Any)
                }
                
                completion(true)
            } else {
                print("MessageService:FindAllMessagesForChannels:AlomoFire.request FAILED!\n")
                debugPrint( response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
    func clearMessages() {
        messages.removeAll()
    }
}

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
    
    func clearChannels() {
        channels.removeAll()
    }
}

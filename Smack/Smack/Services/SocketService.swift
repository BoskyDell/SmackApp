//
//  SocketService.swift
//  Smack
//
//  Created by Kevin Keefe on 12/12/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import UIKit
import SocketIO


class SocketService: NSObject {

    static let instance = SocketService()
    
    override init () {
        super.init()
    }
    
    let manager     = SocketManager(socketURL: URL(string: BASE_URL)!)
    lazy var socket = manager.defaultSocket
    
  //  let socket : SocketIOClient = SocketIOClient(socketUrl: URL(string: BASE_URL)!)
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(id: channelId, channelTitle: channelName, channelDescription: channelDescription)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    // Message Area
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
   //case msgBodyEnm, notUsedEnm, chanIDEnm, userNameEnm, avatarEnm, avatarColorEnm, idEnm, timeStampEnm
    
    func getChatMessage(completion: @escaping CompletionHandler) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msbBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName  = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            if channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                let newMessage = Message(message: msbBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatorColor: userAvatarColor, id: id, timeStamp: timeStamp)
                MessageService.instance.messages.append(newMessage)
                completion(true)
            } else {
                completion(false)
            }
            
        }
    }
    
    
    
    
}

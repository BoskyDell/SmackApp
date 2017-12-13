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
    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!)
    lazy var socket  = manager.defaultSocket
    
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
            
            let newChannel = Channel(id: channelId, channelTitle: channelName, channelDescription: channelDescription, __v: nil)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        
        }
    }
    
    
    
    
    
    
}

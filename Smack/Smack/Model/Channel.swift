//
//  Channel.swift
//  Smack
//
//  Created by Kevin Keefe on 12/9/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import Foundation

struct Channel : Decodable {
    public private(set) var id : String!
    public private(set) var channelTitle : String!
    public private(set) var channelDescription : String!
    //public private(set) var __v : Int?
}

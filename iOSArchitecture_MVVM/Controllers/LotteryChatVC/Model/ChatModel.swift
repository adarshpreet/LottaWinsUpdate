//
//  ChatModel.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/5/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation

struct ChatModel : Codable  {
    
    let avtarID: Int?
    let avtarPic: String?
    let avtarMessage: String?
    let messageID: Int?
    let createdAt : String?
    
    enum ChatModelKeys: String, CodingKey {

        case avtarID = "user"
        case avtarPic = "profile_pic"
        case avtarMessage = "message"
        case messageID = "id"
        case created = "created"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ChatModelKeys.self)
        avtarID = try values.decodeIfPresent(Int.self, forKey: .avtarID)
        messageID = try values.decodeIfPresent(Int.self, forKey: .messageID)

        avtarPic = try values.decodeIfPresent(String.self, forKey: .avtarPic)
        avtarMessage = try values.decodeIfPresent(String.self, forKey: .avtarMessage)
        createdAt = try values.decodeIfPresent(String.self, forKey: .created)

    }
    
    init(id: Int?, pic: String?, message: String?, messageID: Int?, createdAt: String?) {
        self.avtarID = id
        self.messageID = messageID
        self.avtarPic = pic
        self.avtarMessage = message
        self.createdAt = createdAt
    }
}

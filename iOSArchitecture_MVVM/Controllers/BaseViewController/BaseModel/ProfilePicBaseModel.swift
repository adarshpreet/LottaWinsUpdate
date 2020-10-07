//
//  ProfilePicBaseModel.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/7/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
struct ProfilePicBaseModel : Codable {
    let status : Bool?
    let message : String?
    let imagePath : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case imagePath = "image_path"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)
    }

}

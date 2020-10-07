//
//  VerifyBase.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/22/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
struct VerifiedBase : Codable {
    let message : String?
    var isVerified : Bool?

    enum VerifiedKeys: String, CodingKey {

        case message = "message"
        case isVerified = "is_verified"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified)
    }

}

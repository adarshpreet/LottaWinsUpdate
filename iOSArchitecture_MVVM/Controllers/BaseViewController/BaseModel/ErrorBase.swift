//
//  ErrorBase.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/11/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation

struct ErrorBase : Codable {
    let message : ErrorMessageBase?

    enum CodingKeys: String, CodingKey {

        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(ErrorMessageBase.self, forKey: .message)
    }
}

struct ErrorMessageBase : Codable {
    let message : [String]?

    enum CodingKeys: String, CodingKey {

        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent([String].self, forKey: .message)
    }

}

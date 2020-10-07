//
//  SponsoredContent.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/2/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation

struct SponsoredContent : Codable {
    let id : Int?
    let client : Int?
    let title : String?
    let file : String?
    let is_adult : Bool?
    let is_active : Bool?
    let is_watched : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case client = "client"
        case title = "title"
        case file = "file"
        case is_adult = "is_adult"
        case is_active = "is_active"
        case is_watched = "is_watched"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        client = try values.decodeIfPresent(Int.self, forKey: .client)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        file = try values.decodeIfPresent(String.self, forKey: .file)
        is_adult = try values.decodeIfPresent(Bool.self, forKey: .is_adult)
        is_active = try values.decodeIfPresent(Bool.self, forKey: .is_active)
        is_watched = try values.decodeIfPresent(Bool.self, forKey: .is_watched)
    }

}

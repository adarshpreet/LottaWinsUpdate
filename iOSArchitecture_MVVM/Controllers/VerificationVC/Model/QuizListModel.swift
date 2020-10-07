//
//  QuizListModel.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/2/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation

struct QuizListModel : Codable {
    let id : Int?
    let client : Int?
    let title : String?
    let type : String?
    let options : [String]?
    let image : String?
    let is_active : Bool?
    let is_taken : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case client = "client"
        case title = "title"
        case type = "type"
        case options = "options"
        case image = "image"
        case is_active = "is_active"
        case is_taken = "is_taken"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        client = try values.decodeIfPresent(Int.self, forKey: .client)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        options = try values.decodeIfPresent([String].self, forKey: .options)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        is_active = try values.decodeIfPresent(Bool.self, forKey: .is_active)
        is_taken = try values.decodeIfPresent(Bool.self, forKey: .is_taken)
    }

}

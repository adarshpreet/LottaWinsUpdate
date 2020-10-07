//
//  GiveAwayDetail.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/1/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation

struct GiveAwayDetail : Codable {
    let id : Int?
    let name : String?
    let client : Int?
    let type : String?
    let prize_money : String?
    let entry_fee : Int?
    let has_survey : Bool?
    var coins : Int?
    let uuid : String?
    let has_sponsored_content : Bool?
    let start_time : String?
    let end_time : String?
    let created : String?
    let modified : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case client = "client"
        case type = "type"
        case prize_money = "prize_money"
        case entry_fee = "entry_fee"
        case has_survey = "has_survey"
        case coins = "coins"
        case uuid = "uuid"
        case has_sponsored_content = "has_sponsored_content"
        case start_time = "start_time"
        case end_time = "end_time"
        case created = "created"
        case modified = "modified"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        client = try values.decodeIfPresent(Int.self, forKey: .client)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        prize_money = try values.decodeIfPresent(String.self, forKey: .prize_money)
        entry_fee = try values.decodeIfPresent(Int.self, forKey: .entry_fee)
        has_survey = try values.decodeIfPresent(Bool.self, forKey: .has_survey)
        coins = try values.decodeIfPresent(Int.self, forKey: .coins)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        has_sponsored_content = try values.decodeIfPresent(Bool.self, forKey: .has_sponsored_content)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        modified = try values.decodeIfPresent(String.self, forKey: .modified)
    }

}

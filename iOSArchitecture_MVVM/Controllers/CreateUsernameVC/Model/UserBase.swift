/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct UserProfile : Codable {
    let id : Int?
    let username : String?
    let first_name : String?
    let last_name : String?
    let phone_number : String?
    let email : String?
    let dob : String?
    let profile_pic : String?
    var coins : Int?
    let total_winning_amount : String?
    let available_winning_amount : String?
    let enable_location : Bool?
    let enable_notification : Bool?
    let is_skipped : Bool? // photo skipped
    let skipped_notification : Bool? // notification skiped
    let is_verified : Bool? // email verified or not

    enum UserProfileKeys: String, CodingKey {

        case id = "id"
        case username = "username"
        case first_name = "first_name"
        case last_name = "last_name"
        case phone_number = "phone_number"
        case email = "email"
        case dob = "dob"
        case profile_pic = "profile_pic"
        case coins = "coins"
        case total_winning_amount = "total_winning_amount"
        case available_winning_amount = "available_winning_amount"
        case enable_location = "enable_location"
        case enable_notification = "enable_notification"
        case is_skipped = "is_skipped"
        case skipped_notification = "skipped_notification"
        case is_verified = "is_verified"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UserProfileKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        coins = try values.decodeIfPresent(Int.self, forKey: .coins)
        total_winning_amount = try values.decodeIfPresent(String.self, forKey: .total_winning_amount)
        available_winning_amount = try values.decodeIfPresent(String.self, forKey: .available_winning_amount)
        enable_location = try values.decodeIfPresent(Bool.self, forKey: .enable_location)
        enable_notification = try values.decodeIfPresent(Bool.self, forKey: .enable_notification)
        skipped_notification = try values.decodeIfPresent(Bool.self, forKey: .skipped_notification)
        is_skipped = try values.decodeIfPresent(Bool.self, forKey: .is_skipped)
        is_verified = try values.decodeIfPresent(Bool.self, forKey: .is_verified)
        
        if (try? values.decodeIfPresent(Int.self, forKey: .phone_number)) == nil {
           self.phone_number = try values.decodeIfPresent(String.self, forKey: .phone_number)
        } else if (try? values.decodeIfPresent(Int.self, forKey: .phone_number)) != nil {
           let number = try values.decodeIfPresent(Int.self, forKey: .phone_number)
           self.phone_number = "\(number ?? 0)"
        } else {
           self.phone_number = ""
        }
    }
}


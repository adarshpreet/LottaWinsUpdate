

import Foundation


struct GiveAwayListBase : Codable {
    let id : Int?
    let name : String?
    let client : Client_Logo?
    let type : String?
    let prize_type : String?
    var prize_money : String? = nil
    let cover_image : Cover_image?
    let entry_fee : Int?
    let start_time : String?
    let end_time : String?
    let created : String?
    let modified : String?
    let is_adult : Bool?
    let isAge_confirmation_box : Bool?
    let user_count : Int?
    let chatID : String?
    var giveaway_access : Bool?
    let ticketImage: Ticket_Image?
    let pinned_message : String?
    let is_prize_amount_hidden : Bool?
    let winner_page_logo : String?


    enum GiveAwayKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case client = "client"
        case type = "type"
        case prize_money = "prize_money"
        case cover_image = "cover_image"
        case entry_fee = "entry_fee"
        case start_time = "start_time"
        case end_time = "end_time"
        case created = "created"
        case modified = "modified"
        case is_adult = "is_adult"
        case age_confirmation_box = "age_confirmation_box"
        case user_count = "user_count"
        case giveaway_access = "giveaway_access"
        case uuid = "uuid"
        case ticket_image = "ticket_image"
        case pinned_message = "pinned_message"
        case is_prize_amount_hidden = "is_prize_amount_hidden"
        case prize_type = "prize_type"
        case winner_page_logo = "winner_page_logo"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GiveAwayKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        client = try values.decodeIfPresent(Client_Logo.self, forKey: .client)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        
        if (try? values.decodeIfPresent(String.self, forKey: .prize_money)) != nil {
            self.prize_money = try values.decodeIfPresent(String.self, forKey: .prize_money)
        } else {
           self.prize_money = ""
        }
        
        cover_image = try values.decodeIfPresent(Cover_image.self, forKey: .cover_image)
        entry_fee = try values.decodeIfPresent(Int.self, forKey: .entry_fee)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        modified = try values.decodeIfPresent(String.self, forKey: .modified)
        pinned_message = try values.decodeIfPresent(String.self, forKey: .pinned_message)
        is_prize_amount_hidden = try values.decodeIfPresent(Bool.self, forKey: .is_prize_amount_hidden)

        is_adult = try values.decodeIfPresent(Bool.self, forKey: .is_adult)
        isAge_confirmation_box = try values.decodeIfPresent(Bool.self, forKey: .age_confirmation_box)
        giveaway_access = try values.decodeIfPresent(Bool.self, forKey: .giveaway_access)
        chatID = try values.decodeIfPresent(String.self, forKey: .uuid)
        user_count = try values.decodeIfPresent(Int.self, forKey: .user_count)
        ticketImage = try values.decodeIfPresent(Ticket_Image.self, forKey: .ticket_image)
        prize_type = try values.decodeIfPresent(String.self, forKey: .prize_type)
        winner_page_logo = try values.decodeIfPresent(String.self, forKey: .winner_page_logo)

    }

}

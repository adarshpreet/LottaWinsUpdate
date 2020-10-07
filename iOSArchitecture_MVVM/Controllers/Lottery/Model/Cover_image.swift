

import Foundation
struct Cover_image : Codable {
    let id : Int?
    let title : String?
    let image : String?
    let thumbnail : String?

    enum Cover_imageCodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case file = "file"
        case thumbnail = "thumbnail"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Cover_imageCodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        image = try values.decodeIfPresent(String.self, forKey: .file)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)

    }

}

struct Ticket_Image : Codable {
    let id : Int?
    let title : String?
    let image : String?

    enum Ticket_ImageCodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case image = "image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Ticket_ImageCodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }

}

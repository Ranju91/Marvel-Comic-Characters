
import Foundation
struct ResultsModel : Codable {
	let id : Int?
	let name : String?
	let thumbnail : ThumbnailModel?
    let comicsDetail : EventsModel?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case thumbnail = "thumbnail"
        case comicsDetail = "comics"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		thumbnail = try values.decodeIfPresent(ThumbnailModel.self, forKey: .thumbnail)
        comicsDetail = try values.decodeIfPresent(EventsModel.self, forKey: .comicsDetail)
	}
}

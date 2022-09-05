
import Foundation
struct EventsModel : Codable {
	let items : [ItemsModel]?

	enum CodingKeys: String, CodingKey {
		case items = "items"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		items = try values.decodeIfPresent([ItemsModel].self, forKey: .items)
	}
}

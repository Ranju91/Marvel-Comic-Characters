
import Foundation
struct ThumbnailModel : Codable {
	let path : String?
	let extensionValue : String?

	enum CodingKeys: String, CodingKey {

		case path = "path"
		case extensionValue = "extension"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		path = try values.decodeIfPresent(String.self, forKey: .path)
        extensionValue = try values.decodeIfPresent(String.self, forKey: .extensionValue)
	}

}

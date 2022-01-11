public struct Finish: Codable {
    public let id: Int
    public let name: String
    public let imageURL: String?
    public let iconImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
        case iconImageURL = "icon_image_url"
    }
}

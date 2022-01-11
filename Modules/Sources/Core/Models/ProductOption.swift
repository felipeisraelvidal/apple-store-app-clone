public struct ProductOption: Codable {
    public let id: Int
    public let name: String
    public let imageURL: String?
    public let price: Double
    public let specs: [String]
    public let availableFinishes: [Finish]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
        case price
        case specs
        case availableFinishes = "available_finishes"
    }
}

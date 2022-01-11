import Foundation

public struct Product: Codable {
    public let id: Int
    public let model: Model
    public let family: Family
    public let name: String
    public let imageURL: String?
    public let startingPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case model
        case family
        case name
        case imageURL = "image_url"
        case startingPrice = "starting_price"
    }
}

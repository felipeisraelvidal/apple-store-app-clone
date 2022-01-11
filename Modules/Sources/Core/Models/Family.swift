import Foundation

public struct Family: Codable {
    public let id: Int
    public let name: String
    public let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
    }
}

public struct ProductOptionCustomization: Codable, Hashable {
    
    public let id: Int
    public let name: String
    public let items: [Item]
    public let priceChangeMethod: PriceChangeMethod
    
    public static func == (lhs: ProductOptionCustomization, rhs: ProductOptionCustomization) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(priceChangeMethod)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case items
        case priceChangeMethod = "price_change_method"
    }
}

public extension ProductOptionCustomization {
    struct Item: Codable, Equatable {
        public let id: Int
        public let name: String
        public let price: Double?
    }
    
    enum PriceChangeMethod: String, Codable {
        case doNothing = "none"
        case sumBasePrice = "sum_base_price"
        case changeBasePrice = "change_base_price"
    }
}

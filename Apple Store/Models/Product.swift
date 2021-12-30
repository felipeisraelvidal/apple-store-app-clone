//
//  Product.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let imageURL: String?
    let availableColors: [String]?
    let startingPrice: Double
    let family: ProductFamily?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
        case availableColors = "available_colors"
        case startingPrice = "starting_price"
        case family
    }
}

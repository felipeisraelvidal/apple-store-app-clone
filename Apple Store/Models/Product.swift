//
//  Product.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import Foundation

struct Product: Codable {
    let id: Int
    let model: String?
    let name: String
    let imageURL: String?
    let availableColors: [String]?
    let startingPrice: Double
    let family: ProductFamily?
    let options: [Option]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case model
        case name
        case imageURL = "image_url"
        case availableColors = "available_colors"
        case startingPrice = "starting_price"
        case family
        case options
    }
}

extension Product {
    
    struct Option: Codable {
        let id: Int
        let name: String
        let imageURL: String?
        let specs: [String]?
        let price: Double?
        let availableFinishes: [Finish]?
        let customizations: [Customization]?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case imageURL = "image_url"
            case specs
            case price
            case availableFinishes = "available_finishes"
            case customizations
        }
    }
    
    struct Finish: Codable {
        let rawValue: String
        let name: String
        let imageURL: String?
        
        enum CodingKeys: String, CodingKey {
            case rawValue = "raw_value"
            case name
            case imageURL = "image_url"
        }
    }
    
    struct Customization: Codable {
        let id: Int
        let name: String
        let options: [Option]
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case options
        }
        
        enum PriceChangeMethod: String, Codable {
            case none = "none"
            case sumBasePrice = "sum_base_price"
            case change_base_price = "change_base_price"
        }
        
        struct Option: Codable {
            let id: Int
            let name: String
            let price: Double
            let priceChangeMethod: PriceChangeMethod?
            
            enum CodingKeys: String, CodingKey {
                case id
                case name
                case price
                case priceChangeMethod = "price_change_method"
            }
        }
    }
    
}

//
//  Product.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import Foundation

struct Product: Codable {
    let id: Int
    let model: ProductModel
    let name: String
    let imageURL: String?
    let availableColors: [String]?
    let startingPrice: Double
    let family: ProductFamily?
    
    enum CodingKeys: String, CodingKey {
        case id
        case model
        case name
        case imageURL = "image_url"
        case availableColors = "available_colors"
        case startingPrice = "starting_price"
        case family
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
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case imageURL = "image_url"
            case specs
            case price
            case availableFinishes = "available_finishes"
        }
    }
    
    struct Finish: Codable {
        let id: Int
        let name: String
        let imageURL: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case imageURL = "image_url"
        }
    }
    
    struct Customization: Codable, Equatable, Hashable {
        let id: Int
        let name: String
        let items: [Option]
        let priceChangeMethod: PriceChangeMethod
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case items
            case priceChangeMethod = "price_change_method"
        }
        
        static func == (lhs: Product.Customization, rhs: Product.Customization) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(name)
            hasher.combine(priceChangeMethod)
        }
        
        enum PriceChangeMethod: String, Codable {
            case doNothing = "none"
            case sumBasePrice = "sum_base_price"
            case changeBasePrice = "change_base_price"
        }
        
        struct Option: Codable, Equatable {
            let id: Int
            let name: String
            let price: Double?
            
            enum CodingKeys: String, CodingKey {
                case id
                case name
                case price
            }
        }
    }
    
}

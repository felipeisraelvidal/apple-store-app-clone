//
//  ProductFamily.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import Foundation

struct ProductFamily: Codable {
    let id: Int
    let name: String
    let imageURL: String?
    
    enum CondingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
    }
}

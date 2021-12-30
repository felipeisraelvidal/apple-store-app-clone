//
//  NetworkManager.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    func getFamilies(_ completion: @escaping (Result<[ProductFamily], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "families", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let families = try decoder.decode([ProductFamily].self, from: data)
                completion(.success(families))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getModels(for family: ProductFamily, _ completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "products_models", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let models = try decoder.decode([ProductModel].self, from: data)
                let filtered = models.filter({ $0.family?.id == family.id })
                completion(.success(filtered))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

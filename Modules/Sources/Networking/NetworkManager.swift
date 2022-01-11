//
//  File.swift
//  
//
//  Created by Felipe Vidal on 09/01/22.
//

import Foundation
import Combine
import Core

public final class NetworkManager {
    public static let shared = NetworkManager()
    
    private let baseURL = "http://192.168.15.114:3000"
    
    private var anyCancelable = Set<AnyCancellable>()
    
    private func request<T: Codable>(url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        let decoder = JSONDecoder()
        
        return Future { [unowned self] promise in
            URLSession.shared.dataTaskPublisher(for: url)
                .retry(1)
                .mapError({ $0 })
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: type, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(error))
                    }
                } receiveValue: { result in
                    promise(.success(result))
                }
                .store(in: &self.anyCancelable)
        }
        .eraseToAnyPublisher()
    }
    
    public func getFamilies() -> AnyPublisher<[Family], Error> {
        let url = URL(string: "\(baseURL)/families")!
        
        return request(url: url, type: [Family].self)
    }
    
    public func getFamilyProducts(familyId: Int) -> AnyPublisher<[Product], Error> {
        let url = URL(string: "\(baseURL)/families/\(familyId)/products")!
        
        return request(url: url, type: [Product].self)
    }
    
    public func getProductOptions(productId: Int) -> AnyPublisher<[ProductOption], Error> {
        let url = URL(string: "\(baseURL)/products/\(productId)/options")!
        
        return request(url: url, type: [ProductOption].self)
    }
    
    public func getProductOptionCustomizations(productId: Int, productOptionId: Int) -> AnyPublisher<[ProductOptionCustomization], Error> {
        let url = URL(string: "\(baseURL)/products/\(productId)/options/\(productOptionId)/customizations")!
        
        return request(url: url, type: [ProductOptionCustomization].self)
    }
    
}

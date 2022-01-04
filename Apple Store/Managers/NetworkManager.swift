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
    
    private let baseURL = "http://localhost:3000"
    
    private var anyCancelable = Set<AnyCancellable>()
    
    func getFamilies() -> AnyPublisher<[ProductFamily], Error> {
        let url = URL(string: "\(baseURL)/families")
        
        let decoder = JSONDecoder()
        
        return Future { [unowned self] promise in
            URLSession.shared.dataTaskPublisher(for: url!)
                .retry(1)
                .mapError({ $0 })
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: [ProductFamily].self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Done")
                    case .failure(let error):
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                } receiveValue: { families in
                    promise(.success(families))
                }
                .store(in: &self.anyCancelable)
        }
        .eraseToAnyPublisher()
    }
    
    func getProducts(for family: ProductFamily) -> AnyPublisher<[Product], Error> {
        let url = URL(string: "\(baseURL)/families/\(family.id)/products")
        
        let decoder = JSONDecoder()
        
        return Future { [unowned self] promise in
            URLSession.shared.dataTaskPublisher(for: url!)
                .retry(1)
                .mapError({ $0 })
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: [Product].self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Done")
                    case .failure(let error):
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                } receiveValue: { products in
                    promise(.success(products))
                }
                .store(in: &self.anyCancelable)

        }
        .eraseToAnyPublisher()
    }
    
    func getProductOptions(productId: Int) -> AnyPublisher<[Product.Option], Error> {
        let url = URL(string: "\(baseURL)/products/\(productId)/options")
        
        let decoder = JSONDecoder()
        
        return Future { [unowned self] promise in
            URLSession.shared.dataTaskPublisher(for: url!)
                .retry(1)
                .mapError({ $0 })
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: [Product.Option].self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Done")
                    case .failure(let error):
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                } receiveValue: { options in
                    promise(.success(options))
                }
                .store(in: &self.anyCancelable)
        }
        .eraseToAnyPublisher()
    }
}

//
//  ProductFamilyViewModel.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import Foundation
import Combine

class ProductFamilyViewModel {
    @Published private(set) var models: [Product] = []
    
    private var anyCancelable = Set<AnyCancellable>()
    
    func fetchModels(for family: ProductFamily) {
        NetworkManager.shared.getProducts(for: family)
            .receive(on: DispatchQueue.main)
            .map({ $0 })
            .sink { _ in
                
            } receiveValue: { [unowned self] products in
                self.models = products
            }
            .store(in: &self.anyCancelable)
    }
}

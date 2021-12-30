//
//  ProductFamilyViewModel.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import Foundation

class ProductFamilyViewModel {
    @Published private(set) var models: [Product] = []
    
    func fetchModels(for family: ProductFamily) {
        NetworkManager.shared.getModels(for: family) { result in
            switch result {
            case .success(let models):
                self.models = models
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

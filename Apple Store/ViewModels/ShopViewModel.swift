//
//  ShopViewModel.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import Foundation

final class ShopViewModel {
    
    @Published private(set) var families: [ProductFamily] = []
    
    func fetchFamilies() {
        NetworkManager.shared.getFamilies { result in
            switch result {
            case .success(let families):
                self.families = families
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

//
//  ShopViewModel.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import Foundation
import Combine

final class ShopViewModel {
    
    @Published private(set) var families: [ProductFamily] = []
    
    private var anyCancelable = Set<AnyCancellable>()
    
    func fetchFamilies() {
        families = []
        
        NetworkManager.shared.getFamilies()
            .receive(on: DispatchQueue.main)
            .map({ $0 })
            .sink { _ in
                
            } receiveValue: { [weak self] families in
                self?.families = families
            }
            .store(in: &self.anyCancelable)
    }
    
}

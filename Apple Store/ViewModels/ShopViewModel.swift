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
    @Published private(set) var isLoading = false
    
    private var anyCancelable = Set<AnyCancellable>()
    
    func fetchFamilies() {
        families = []
        isLoading = true
        
        NetworkManager.shared.getFamilies()
            .receive(on: DispatchQueue.main)
            .map({ $0 })
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [unowned self] families in
                self.families = families
            }
            .store(in: &self.anyCancelable)
    }
    
}

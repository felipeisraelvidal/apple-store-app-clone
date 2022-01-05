//
//  BuyProductViewModel.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import Foundation
import Combine

final class BuyProductViewModel {
    private(set) var selectedProduct: Product
    
    @Published private(set) var productOptions: [Product.Option] = []
    @Published private(set) var isLoading = false
    
    private var anyCancelable = Set<AnyCancellable>()
    
    init(selectedProduct: Product) {
        self.selectedProduct = selectedProduct
    }
    
    func fetchProductOptions() {
        self.isLoading = true
        
        NetworkManager.shared.getProductOptions(productId: selectedProduct.id)
            .receive(on: DispatchQueue.main)
            .map({ $0 })
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [unowned self] options in
                self.productOptions = options
            }
            .store(in: &self.anyCancelable)
    }
}

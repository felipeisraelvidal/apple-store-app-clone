//
//  BuyProductViewModel.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import Foundation

final class BuyProductViewModel {
    private(set) var selectedProduct: Product
    
    init(selectedProduct: Product) {
        self.selectedProduct = selectedProduct
    }
}

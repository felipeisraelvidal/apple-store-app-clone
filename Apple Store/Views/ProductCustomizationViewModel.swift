//
//  ProductCustomizationViewModel.swift
//  Apple Store
//
//  Created by Felipe Vidal on 31/12/21.
//

import Foundation

final class ProductCustomizationViewModel {
    
    private(set) var selectedProduct: Product
    private(set) var selectedOption: Product.Option
    
    var customizedOption: Product.Option
    
    init(selectedProduct: Product, selectedOption: Product.Option) {
        self.selectedProduct = selectedProduct
        self.selectedOption = selectedOption
        
        self.customizedOption = selectedOption
    }
    
}

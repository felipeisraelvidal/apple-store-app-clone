//
//  ProductDetailsViewModel.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import Foundation

final class ProductDetailsViewModel {
    
    private(set) var selectedProductModel: ProductModel!
    
    init(selectedProductModel: ProductModel) {
        self.selectedProductModel = selectedProductModel
    }
}

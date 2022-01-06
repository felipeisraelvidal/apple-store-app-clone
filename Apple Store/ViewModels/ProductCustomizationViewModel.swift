//
//  ProductCustomizationViewModel.swift
//  Apple Store
//
//  Created by Felipe Vidal on 31/12/21.
//

import Foundation
import Combine

final class ProductCustomizationViewModel {
    
    private(set) var selectedProduct: Product
    private(set) var selectedOption: Product.Option
    private(set) var selectedFinish: Product.Finish?
    
    @Published private(set) var customizations: [Product.Customization] = []
    @Published private(set) var isLoading = false
    
    private var anyCancelable = Set<AnyCancellable>()
    
    @Published private(set) var finalPrice: Double
    
    @Published var options: [Product.Customization: Product.Customization.Option?] = [:]
    
    var finalPricePublisher: AnyPublisher<Double, Never> {
        return $options
            .receive(on: DispatchQueue.main)
            .map { [weak self] dict in
                var basePrice = self?.selectedOption.price ?? 0
                var additionalPrice: Double = 0
                
                let toChangeBasePrice = dict
                    .filter({ $0.key.priceChangeMethod == .changeBasePrice })
                
                if let toChangeBasePrice = toChangeBasePrice.first {
                    basePrice = toChangeBasePrice.value?.price ?? 0
                }
                
                additionalPrice = dict
                    .filter({ $0.key.priceChangeMethod == .sumBasePrice })
                    .map({ $0.value?.price ?? 0 })
                    .reduce(0, +)
                
                return basePrice + additionalPrice
            }
            .eraseToAnyPublisher()
    }
    
    private var finalPriceSubscriber: AnyCancellable?
    
    init(selectedProduct: Product, selectedOption: Product.Option, selectedFinish: Product.Finish?) {
        self.selectedProduct = selectedProduct
        self.selectedOption = selectedOption
        self.selectedFinish = selectedFinish
        
//        self.basePrice = selectedOption.price ?? 0
        self.finalPrice = selectedOption.price ?? 0
        
        finalPriceSubscriber = finalPricePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.finalPrice, on: self)
        
//        for customization in selectedOption.customizations ?? [] {
//            options[customization] = customization.items.first
//        }
    }
    
    func fetchProductOptionCustomizations() {
        self.isLoading = true
        
        NetworkManager.shared.getProductOptionCustomizations(productId: selectedProduct.id, optionId: selectedOption.id)
            .receive(on: DispatchQueue.main)
            .map({ $0 })
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [unowned self] customizations in
                self.customizations = customizations
            }
            .store(in: &self.anyCancelable)
    }
    
    func addCustomization(_ customization: Product.Customization, option: Product.Customization.Option) {
        options[customization] = option
    }
    
}

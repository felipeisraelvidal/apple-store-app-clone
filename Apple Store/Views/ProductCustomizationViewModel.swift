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
    
//    @Published private var basePrice: Double
//    @Published private var additionalPrice: Double = 0
    
    @Published private(set) var finalPrice: Double
    
    @Published var options: [Product.Customization: Product.Customization.Option?] = [:]
    
//    var finalPricePublisher: AnyPublisher<Double, Never> {
//        return Publishers.CombineLatest($basePrice, $additionalPrice)
//            .receive(on: DispatchQueue.main)
//            .map { basePrice, additionalPrice in
//                return basePrice + additionalPrice
//            }
//            .eraseToAnyPublisher()
//    }
    
    var testPublisher: AnyPublisher<Double, Never> {
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
    
    init(selectedProduct: Product, selectedOption: Product.Option) {
        self.selectedProduct = selectedProduct
        self.selectedOption = selectedOption
        
//        self.basePrice = selectedOption.price ?? 0
        self.finalPrice = selectedOption.price ?? 0
        
        finalPriceSubscriber = testPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.finalPrice, on: self)
        
        for customization in selectedOption.customizations ?? [] {
            options[customization] = customization.options.first
        }
    }
    
    func addCustomization(_ customization: Product.Customization, option: Product.Customization.Option) {
        options[customization] = option
        
//        if let price = option.price {
//            switch customization.priceChangeMethod {
//            case .changeBasePrice:
//                self.basePrice = price
//            case .sumBasePrice:
//                self.additionalPrice = options
//                    .filter({ $0.key.priceChangeMethod == .sumBasePrice })
//                    .map({ $0.value?.price ?? 0 })
//                    .reduce(0, +)
//            default:
//                break
//            }
//        } else {
//            switch customization.priceChangeMethod {
//            case .changeBasePrice:
//                self.basePrice = self.selectedOption.price ?? 0
//            case .sumBasePrice:
//                self.additionalPrice = options
//                    .filter({ $0.key.priceChangeMethod == .sumBasePrice })
//                    .map({ $0.value?.price ?? 0 })
//                    .reduce(0, +)
//            default:
//                break
//            }
//        }
    }
    
}

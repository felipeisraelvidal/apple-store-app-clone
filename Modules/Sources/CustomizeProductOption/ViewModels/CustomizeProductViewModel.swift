import Foundation
import Core
import Combine
import Networking

public final class CustomizeProductViewModel {
    
    public private(set) var selectedProduct: Product
    public private(set) var selectedProductOption: ProductOption
    public private(set) var selectedFinish: Finish?
    
    @Published public private(set) var customizations: [ProductOptionCustomization] = []
    @Published public private(set) var isLoading: Bool = false
    
    @Published var selectedCustomizations: [ProductOptionCustomization: ProductOptionCustomization.Item?] = [:]
    
    private var anyCancelable = Set<AnyCancellable>()
    
    @Published private(set) var finalPrice: Double
    
    var finalPricePublisher: AnyPublisher<Double, Never> {
        return $selectedCustomizations
            .receive(on: DispatchQueue.main)
            .map { [weak self] dict in
                var basePrice = self?.selectedProductOption.price ?? 0
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
    
    public init(selectedProduct: Product, selectedProductOption: ProductOption, selectedFinish: Finish?) {
        self.selectedProduct = selectedProduct
        self.selectedProductOption = selectedProductOption
        self.selectedFinish = selectedFinish
        
        self.finalPrice = selectedProductOption.price
        
        finalPriceSubscriber = finalPricePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.finalPrice, on: self)
    }
    
    public func fetchCustomizations() {
        customizations = []
        isLoading = true
        
        NetworkManager.shared.getProductOptionCustomizations(productId: selectedProduct.id, productOptionId: selectedProductOption.id)
            .receive(on: DispatchQueue.main)
            .map({ $0 })
            .sink { [weak self] result in
                switch result {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.isLoading = false
            } receiveValue: { [weak self] customizations in
                self?.customizations = customizations
                
                for customization in customizations {
                    self?.selectedCustomizations[customization] = customization.items.first
                }
            }
            .store(in: &self.anyCancelable)
    }
    
    func addCustomization(_ customization: ProductOptionCustomization, item: ProductOptionCustomization.Item) {
        selectedCustomizations[customization] = item
    }
    
}

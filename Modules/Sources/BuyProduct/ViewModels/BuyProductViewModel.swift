import Foundation
import Core
import Networking
import Combine

public final class BuyProductViewModel {
    
    public private(set) var product: Product
    
    @Published private(set) var productOptions: [ProductOption] = []
    @Published private(set) var isLoading: Bool = false
    
    private var anyCancelable = Set<AnyCancellable>()
    
    public init(product: Product) {
        self.product = product
    }
    
    public func fetchFamilies() {
        productOptions = []
        isLoading = true
        
        NetworkManager.shared.getProductOptions(productId: product.id)
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
            } receiveValue: { [weak self] productOptions in
                self?.productOptions = productOptions
            }
            .store(in: &self.anyCancelable)
    }
    
}

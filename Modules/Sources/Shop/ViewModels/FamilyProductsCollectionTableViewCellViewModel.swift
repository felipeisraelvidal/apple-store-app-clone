import Foundation
import Core
import Networking
import Combine

public final class FamilyProductsCollectionTableViewCellViewModel {
    
    private var family: Family
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading: Bool = false
    
    private var anyCancelable = Set<AnyCancellable>()
    
    public init(family: Family) {
        self.family = family
    }
    
    public func fetchProducts() {
        products = []
        isLoading = true
        
        NetworkManager.shared.getFamilyProducts(familyId: family.id)
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
            } receiveValue: { [weak self] products in
                self?.products = products
            }
            .store(in: &self.anyCancelable)
    }
    
}

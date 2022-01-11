import Foundation
import Core
import Networking
import Combine

public final class ShopViewModel {
    
    @Published private(set) var families: [Family] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private var anyCancelable = Set<AnyCancellable>()
    
    public init() {}
    
    public func fetchFamilies() {
        families = []
        isLoading = true
        
        NetworkManager.shared.getFamilies()
            .receive(on: DispatchQueue.main)
            .map({ $0 })
            .sink { [weak self] result in
                self?.isLoading = false
                
                switch result {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] families in
                self?.families = families
            }
            .store(in: &self.anyCancelable)
    }
    
}

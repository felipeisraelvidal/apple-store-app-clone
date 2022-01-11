import Core
import Combine

public final class ProductOptionViewModel {
    
    public private(set) var productOption: ProductOption
    
    @Published public var selectedFinish: Finish?
    
    public init(productOption: ProductOption) {
        self.productOption = productOption
        
        selectedFinish = productOption.availableFinishes?.first
    }
    
}

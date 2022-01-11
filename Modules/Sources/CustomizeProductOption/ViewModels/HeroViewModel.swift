import Core

public final class HeroViewModel {
    
    public private(set) var selectedProduct: Product
    public private(set) var selectedProductOption: ProductOption
    public private(set) var selectedFinish: Finish?
    
    public init(selectedProduct: Product, selectedProductOption: ProductOption, selectedFinish: Finish?) {
        self.selectedProduct = selectedProduct
        self.selectedProductOption = selectedProductOption
        self.selectedFinish = selectedFinish
    }
    
}

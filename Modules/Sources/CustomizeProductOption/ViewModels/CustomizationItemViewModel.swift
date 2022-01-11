import Core

public final class CustomizationItemViewModel {
    
    public private(set) var item: ProductOptionCustomization.Item
    public private(set) var priceChangeMethod: ProductOptionCustomization.PriceChangeMethod
    
    public init(item: ProductOptionCustomization.Item, priceChangeMethod: ProductOptionCustomization.PriceChangeMethod) {
        self.item = item
        self.priceChangeMethod = priceChangeMethod
    }
    
}

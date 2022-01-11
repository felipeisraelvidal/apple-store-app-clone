//
//  ShopCoordinator.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import UIKit
import Shop
import Core
import ProductDetails
import BuyProduct
import CustomizeProductOption

class ShopCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ShopViewModel()
        let viewController = ShopViewController(viewModel: viewModel)
        viewController.title = "Shop"
        viewController.tabBarItem.image = UIImage(systemName: "laptopcomputer.and.iphone")
        
        viewController.onSelectProduct = { [weak self] product in
            self?.openProductDetails(product)
        }
        
        viewController.onTapBuyButton = { [weak self] product in
            self?.buyProduct(product)
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func openProductDetails(_ model: Core.Product) {
        let viewModel = ProductDetailsViewModel(
            product: model
        )
        let viewController = ProductDetailsViewController(viewModel: viewModel)
        
        viewController.onTapCloseButton = { [weak self] in
            self?.dismiss(viewController)
        }
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        navigationController.topViewController?.present(navController, animated: true, completion: nil)
    }
    
    func buyProduct(_ model: Core.Product) {
        let viewModel = BuyProductViewModel(product: model)
        let viewController = BuyProductViewController(viewModel: viewModel)
        
        viewController.onTapSelectButton = { [weak self] productOption, selectedFinish in
            self?.customizeProductOption(viewModel.product, option: productOption, selectedFinish: selectedFinish)
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func customizeProductOption(_ product: Core.Product, option: ProductOption, selectedFinish: Finish?) {
        let viewModel = CustomizeProductViewModel(
            selectedProduct: product,
            selectedProductOption: option,
            selectedFinish: selectedFinish
        )
        let viewController = CustomizeProductOptionViewController(
            viewModel: viewModel
        )
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

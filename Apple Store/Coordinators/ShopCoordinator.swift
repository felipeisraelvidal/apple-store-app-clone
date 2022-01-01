//
//  ShopCoordinator.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import UIKit

class ShopCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ShopViewController()
        viewController.title = "Shop"
        viewController.tabBarItem.image = UIImage(systemName: "laptopcomputer.and.iphone")
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func openProductDetails(_ model: Product) {
        let viewModel = ProductDetailsViewModel(selectedProduct: model)
        let viewController = ProductDetailsViewController(viewModel: viewModel)
        viewController.coordinator = self
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        navigationController.topViewController?.present(navController, animated: true, completion: nil)
    }
    
    func buyProduct(_ model: Product) {
        guard let options = model.options, !options.isEmpty else {
            print("This product has no options")
            return
        }
        
        if options.count > 1 {
            // Show options selector
            
            let viewModel = BuyProductViewModel(selectedProduct: model)
            let viewController = BuyProductViewController(viewModel: viewModel)
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        } else {
            // Show product customization
            let viewModel = ProductCustomizationViewModel(selectedProduct: model, selectedOption: options[0])
            let viewController = ProductCustomizationViewController(viewModel: viewModel)
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func customizeProductOption(_ product: Product, option: Product.Option) {
        let viewModel = ProductCustomizationViewModel(selectedProduct: product, selectedOption: option)
        let viewController = ProductCustomizationViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

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
        let viewModel = BuyProductViewModel(selectedProduct: model)
        let viewController = BuyProductViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

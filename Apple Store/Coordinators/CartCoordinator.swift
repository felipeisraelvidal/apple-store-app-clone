//
//  CartCoordinator.swift
//  Apple Store
//
//  Created by Felipe Vidal on 11/01/22.
//

import UIKit
import Cart

class CartCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CartViewModel()
        let viewController = CartViewController(viewModel: viewModel)
        viewController.title = "Cart"
        viewController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "bag"), tag: 1)
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}

//
//  SearchProductsCoordinator.swift
//  Apple Store
//
//  Created by Felipe Vidal on 11/01/22.
//

import UIKit
import SearchProducts

class SearchProductsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SearchProductsViewModel()
        let viewController = SearchProductsViewController(viewModel: viewModel)
        viewController.title = "Search"
        viewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}

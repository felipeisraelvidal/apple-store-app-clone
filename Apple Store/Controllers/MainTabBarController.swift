//
//  MainTabBarController.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let shop = ShopCoordinator(navigationController: UINavigationController())
    let cart = CartCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shop.start()
        cart.start()
        
        viewControllers = [
            shop.navigationController,
            cart.navigationController
        ]
    }
    
}

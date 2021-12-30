//
//  Coordinator.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}


//
//  Coordinator.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import UIKit

protocol Coordinator1: AnyObject {
    var childCoordinators: [Coordinator1] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}


//
//  ProductModelDetailsViewController.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import UIKit

class ProductModelDetailsViewController: UIViewController {
    
    weak var coordinator: ShopCoordinator?
    
    var selectedProductModel: ProductModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        title = selectedProductModel.name
        
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }

}

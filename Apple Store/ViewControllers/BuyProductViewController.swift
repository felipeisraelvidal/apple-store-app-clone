//
//  BuyProductViewController.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import UIKit

class BuyProductViewController: UIViewController {
    
    weak var coordinator: ShopCoordinator?
    
    private var viewModel: BuyProductViewModel
    
    init(viewModel: BuyProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Buy"
        
        view.backgroundColor = .systemBackground
    }

}

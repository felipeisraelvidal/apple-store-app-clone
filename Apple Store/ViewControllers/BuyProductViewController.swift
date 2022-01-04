//
//  BuyProductViewController.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import UIKit
import Combine

class BuyProductViewController: UIViewController {
    
    weak var coordinator: ShopCoordinator?
    
    private var anyCancellable = Set<AnyCancellable>()
    private var viewModel: BuyProductViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        
        tableView.register(BuyProductTitleTableViewCell.self, forCellReuseIdentifier: BuyProductTitleTableViewCell.identifier)
        tableView.register(BuyProductOptionTableViewCell.self, forCellReuseIdentifier: BuyProductOptionTableViewCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .title3, weight: .semibold)
        label.textColor = .secondaryLabel
        label.text = "Loading Product"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(viewModel: BuyProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        title = viewModel.selectedProduct.name
        
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.$productOptions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] test in
                self?.tableView.reloadData()
            }
            .store(in: &anyCancellable)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.tableView.backgroundView = value == true ? self?.loadingLabel : nil
            }
            .store(in: &self.anyCancellable)
        
        fetchProductOptions()
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc private func fetchProductOptions() {
        viewModel.fetchProductOptions()
    }

}

extension BuyProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.productOptions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BuyProductTitleTableViewCell.identifier, for: indexPath) as? BuyProductTitleTableViewCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = "Choose you new \(viewModel.selectedProduct.model.name)"
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BuyProductOptionTableViewCell.identifier, for: indexPath) as? BuyProductOptionTableViewCell else {
                return UITableViewCell()
            }
            
            let option = viewModel.productOptions[indexPath.row]
            cell.configure(with: option)
            
            cell.onTapSelectButton = { [unowned self] productOption in
                self.coordinator?.customizeProductOption(viewModel.selectedProduct, option: productOption)
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

#if DEBUG
import SwiftUI

struct BuyProductViewControllerPreviews: PreviewProvider {
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            ContainerPreview()
                .ignoresSafeArea()
                .environment(\.colorScheme, scheme)
        }
    }
    
    struct ContainerPreview: UIViewControllerRepresentable {
        typealias UIViewControllerType = UITabBarController
        
        func makeUIViewController(context: Context) -> UIViewControllerType {
            let product = Product(
                id: 1,
                model: ProductModel(
                    id: 1,
                    name: "MacBook Air"
                ),
                name: "MacBook Air",
                imageURL: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mac-card-40-macbook-air-202110?wid=1200&hei=1000&fmt=p-jpg&qlt=95&.v=1633726242000",
                availableColors: nil,
                startingPrice: 999,
                family: .init(
                    id: 0,
                    name: "Mac",
                    imageURL: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/store-card-mac-nav-202110?wid=400&hei=260&fmt=png-alpha&.v=1632870674000"
                )
            )
            
            let viewModel = BuyProductViewModel(selectedProduct: product)
            let viewController = BuyProductViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            navController.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "laptopcomputer.and.iphone"), tag: 0)
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [navController]
            
            return tabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif

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
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        
        tableView.register(BuyProductTitleTableViewCell.self, forCellReuseIdentifier: BuyProductTitleTableViewCell.identifier)
        tableView.register(BuyProductOptionTableViewCell.self, forCellReuseIdentifier: BuyProductOptionTableViewCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
            return viewModel.selectedProduct.options?.count ?? 0
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
            
            cell.titleLabel.text = "Choose you new \(viewModel.selectedProduct.model ?? "Model")"
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BuyProductOptionTableViewCell.identifier, for: indexPath) as? BuyProductOptionTableViewCell else {
                return UITableViewCell()
            }
            
            guard let option = viewModel.selectedProduct.options?[indexPath.row] else {
                return UITableViewCell()
            }
            
            cell.configure(with: option)
            
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
        typealias UIViewControllerType = UINavigationController
        
        func makeUIViewController(context: Context) -> UIViewControllerType {
            let product = Product(
                id: 0,
                model: "MacBook Pro",
                name: "MacBook Pro 16\"",
                imageURL: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mac-card-40-macbook-pro-16-202110?wid=1200&hei=1000&fmt=p-jpg&qlt=95&.v=1633726244000",
                availableColors: [
                    "space_gray",
                    "gold",
                    "silver"
                ],
                startingPrice: 2499,
                family: .init(
                    id: 0,
                    name: "Mac",
                    imageURL: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/store-card-mac-nav-202110?wid=400&hei=260&fmt=png-alpha&.v=1632870674000"
                ),
                options: [
                    .init(
                        id: 0,
                        name: "Apple M1 Chip with 8-Core CPU and 7-Core GPU 256GB Storage",
                        imageURL: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000",
                        specs: [
                            "Apple M1 chip with 8‑core CPU, 7‑core GPU, and 16‑core Neural Engine",
                            "8GB unified memory",
                            "256GB SSD storage",
                            "Retina display with True Tone",
                            "Magic Keyboard",
                            "Touch ID",
                            "Force Touch trackpad",
                            "Two Thunderbolt / USB 4 ports"
                        ],
                        price: 999,
                        availableFinishes: nil
                    ),
                    .init(
                        id: 0,
                        name: "Apple M1 Chip with 8-Core CPU and 7-Core GPU 256GB Storage",
                        imageURL: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000",
                        specs: [
                            "Apple M1 chip with 8‑core CPU, 7‑core GPU, and 16‑core Neural Engine",
                            "8GB unified memory",
                            "256GB SSD storage",
                            "Retina display with True Tone",
                            "Magic Keyboard",
                            "Touch ID",
                            "Force Touch trackpad",
                            "Two Thunderbolt / USB 4 ports"
                        ],
                        price: 999,
                        availableFinishes: nil
                    )
                ]
            )
            
            let viewModel = BuyProductViewModel(selectedProduct: product)
            let viewController = BuyProductViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            
            return navController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif

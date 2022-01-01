//
//  ProductCustomizationViewController.swift
//  Apple Store
//
//  Created by Felipe Vidal on 31/12/21.
//

import UIKit

class ProductCustomizationViewController: UIViewController {
    
    weak var coordinator: ShopCoordinator?
    
    private var viewModel: ProductCustomizationViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.allowsMultipleSelection = true
        
        tableView.register(ProductCustomizationHeroTableViewCell.self, forCellReuseIdentifier: ProductCustomizationHeroTableViewCell.identifier)
        tableView.register(CustomizationOptionTableViewCell.self, forCellReuseIdentifier: CustomizationOptionTableViewCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let bottomView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        view.insetsLayoutMarginsFromSafeArea = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        
        let title = "Add to Cart"
        
        let verticalInsets: CGFloat = 10
        let horizontalInsets: CGFloat = 14
        
        let backgroundColor: UIColor = .systemBlue
        let foregroundColor: UIColor = .white
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: verticalInsets, leading: horizontalInsets, bottom: verticalInsets, trailing: horizontalInsets)
            configuration.title = title
            configuration.baseBackgroundColor = backgroundColor
            configuration.baseForegroundColor = foregroundColor
            button.configuration = configuration
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
            button.setTitleColor(foregroundColor, for: .normal)
            button.setTitle(title, for: .normal)
        }
        
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let bottomViewTopSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(viewModel: ProductCustomizationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var frame: CGRect = .zero
        frame.size.height = .leastNormalMagnitude
        let headerView = UIView(frame: frame)
        tableView.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset.bottom = bottomView.bounds.height
        tableView.verticalScrollIndicatorInsets.bottom = bottomView.bounds.height
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
        
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        bottomView.contentView.addSubview(bottomViewTopSeparator)
        
        NSLayoutConstraint.activate([
            bottomViewTopSeparator.topAnchor.constraint(equalTo: bottomView.contentView.topAnchor),
            bottomViewTopSeparator.leadingAnchor.constraint(equalTo: bottomView.contentView.leadingAnchor),
            bottomViewTopSeparator.trailingAnchor.constraint(equalTo: bottomView.contentView.trailingAnchor),
            bottomViewTopSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        bottomView.contentView.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: bottomView.contentView.topAnchor, constant: 10),
            addToCartButton.leadingAnchor.constraint(equalTo: bottomView.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: bottomView.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addToCartButton.bottomAnchor.constraint(equalTo: bottomView.contentView.bottomAnchor, constant: -10)
        ])
        
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
}

extension ProductCustomizationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + (viewModel.selectedOption.customizations?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        default:
            guard let customization = viewModel.selectedOption.customizations?[section - 1] else { return nil }
            
            return customization.name
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            guard let customization = viewModel.selectedOption.customizations?[section - 1] else { return 0 }
            
            return customization.options.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCustomizationHeroTableViewCell.identifier, for: indexPath) as? ProductCustomizationHeroTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel.selectedProduct, option: viewModel.selectedOption)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomizationOptionTableViewCell.identifier, for: indexPath) as? CustomizationOptionTableViewCell else {
                return UITableViewCell()
            }
            
            guard let option = viewModel.selectedOption.customizations?[indexPath.section - 1].options[indexPath.row] else {
                return UITableViewCell()
            }
            
            cell.configure(with: option)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        for ip in tableView.indexPathsForSelectedRows ?? [] {
            if ip.section == indexPath.section && ip.row != indexPath.row {
                tableView.deselectRow(at: ip, animated: true)
            }
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section != 0 {
            guard let headerView = view as? UITableViewHeaderFooterView else { return }
            guard let customization = viewModel.selectedOption.customizations?[section - 1] else { return }
            
            headerView.textLabel?.font = .preferredFont(for: .title3, weight: .bold)
            headerView.textLabel?.text = customization.name.capitalized
            headerView.textLabel?.textColor = .label
        }
    }
    
}

#if DEBUG
import SwiftUI

struct ProductCustomizationViewControllerPreviews: PreviewProvider {
    
    static var previews: some View {
        ContainerPreview()
            .ignoresSafeArea()
    }
    
    struct ContainerPreview: UIViewControllerRepresentable {
        typealias UIViewControllerType = UITabBarController
        
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
            options: nil
        )
        
        let option: Product.Option = .init(
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
            availableFinishes: nil,
            customizations: [
                .init(
                    id: 0,
                    name: "Memory",
                    options: [
                        .init(
                            id: 0,
                            name: "Item 1",
                            price: 0,
                            priceChangeMethod: Product.Customization.PriceChangeMethod.none
                        ),
                        .init(
                            id: 1,
                            name: "Item 2",
                            price: 200,
                            priceChangeMethod: .sumBasePrice
                        )
                    ]
                ),
                .init(
                    id: 1,
                    name: "Storage",
                    options: [
                        .init(
                            id: 0,
                            name: "Item 1",
                            price: 0,
                            priceChangeMethod: Product.Customization.PriceChangeMethod.none
                        ),
                        .init(
                            id: 1,
                            name: "Item 2",
                            price: 200,
                            priceChangeMethod: .sumBasePrice
                        ),
                        .init(
                            id: 2,
                            name: "Item 3",
                            price: 400,
                            priceChangeMethod: .sumBasePrice
                        )
                    ]
                )
            ]
        )
        
        func makeUIViewController(context: Context) -> UIViewControllerType {
            let viewModel = ProductCustomizationViewModel(selectedProduct: product, selectedOption: option)
            let viewController = ProductCustomizationViewController(viewModel: viewModel)
            viewController.tabBarItem = UITabBarItem(title: "Customize", image: UIImage(systemName: "star"), tag: 0)
            let navController = UINavigationController(rootViewController: viewController)
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [navController]
            
            return tabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif

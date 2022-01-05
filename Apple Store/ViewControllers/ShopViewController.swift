//
//  ShopViewController.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import UIKit
import Combine

class ShopViewController: UIViewController {
    
    weak var coordinator: ShopCoordinator?
    
    private var anyCancellable = Set<AnyCancellable>()
    private let viewModel = ShopViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.contentInset.top = 24
        tableView.allowsSelection = false
        tableView.insetsContentViewsToSafeArea = false
        
        tableView.register(ShopProductFamilyCollectionTableViewCell.self, forCellReuseIdentifier: ShopProductFamilyCollectionTableViewCell.identifier)
        tableView.register(ShopProductFamilySectionHeader.self, forHeaderFooterViewReuseIdentifier: ShopProductFamilySectionHeader.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchFamilies()
        
        viewModel.$families
            .receive(on: DispatchQueue.main)
            .sink { [weak self] test in
                self?.tableView.reloadData()
            }
            .store(in: &anyCancellable)
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    @objc private func fetchFamilies() {
        viewModel.fetchFamilies()
    }

}

extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.families.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShopProductFamilySectionHeader.identifier) as? ShopProductFamilySectionHeader else { return nil }

        let family = viewModel.families[section]
        
        headerView.configure(with: family)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShopProductFamilyCollectionTableViewCell.identifier, for: indexPath) as? ShopProductFamilyCollectionTableViewCell else {
            return UITableViewCell()
        }

        let family = viewModel.families[indexPath.section]
        cell.configureCell(with: family)

        cell.onSelectModel = { [weak self] model in
            self?.coordinator?.openProductDetails(model)
        }

        cell.onTapBuyButton = { [weak self] model in
            self?.coordinator?.buyProduct(model)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
}

#if DEBUG
import SwiftUI

struct ShopViewControllerPreviews: PreviewProvider {
    
    static var previews: some View {
        ContainerPreview()
            .ignoresSafeArea()
    }
    
    struct ContainerPreview: UIViewControllerRepresentable {
        typealias UIViewControllerType = UITabBarController
        
        func makeUIViewController(context: Context) -> UIViewControllerType {
            let coordinator = ShopCoordinator(navigationController: UINavigationController())
            coordinator.start()
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [coordinator.navigationController]
            
            return tabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif

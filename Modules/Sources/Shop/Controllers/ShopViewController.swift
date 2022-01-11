import UIKit
import Combine
import Core

public class ShopViewController: UIViewController {
    
    private var viewModel: ShopViewModel
    
    private var anyCancellable = Set<AnyCancellable>()
    
    public var onTapBuyButton: ((Product) -> Void)?
    public var onSelectProduct: ((Product) -> Void)?
    
    public init(viewModel: ShopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.contentInset.top = 24
        tableView.insetsContentViewsToSafeArea = false
        
        tableView.register(FamilyProductsCollectionTableViewCell.self, forCellReuseIdentifier: FamilyProductsCollectionTableViewCell.identifier)
        
        tableView.register(FamilyShopTableSectionHeader.self, forHeaderFooterViewReuseIdentifier: FamilyShopTableSectionHeader.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tintColor = .systemGray
        return indicator
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shop"
        
        configureNavigationBar()
        
        view.backgroundColor = .systemGroupedBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Assing publishers
        viewModel.$families
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &anyCancellable)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.tableView.backgroundView = isLoading ? self?.loadingIndicator : nil
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &anyCancellable)
        
        fetchFamilies()
    }
    
    public override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Functions
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func fetchFamilies() {
        viewModel.fetchFamilies()
    }
    
}

extension ShopViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.families.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FamilyShopTableSectionHeader.identifier) as? FamilyShopTableSectionHeader else {
            return nil
        }
        
        let family = viewModel.families[section]
        headerView.configure(with: family)
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FamilyProductsCollectionTableViewCell.identifier, for: indexPath) as? FamilyProductsCollectionTableViewCell else {
            return UITableViewCell()
        }
        
        let family = viewModel.families[indexPath.section]
        let viewModel = FamilyProductsCollectionTableViewCellViewModel(
            family: family
        )
        cell.configure(with: viewModel)
        
        cell.onTapBuyButton = { [weak self] product in
            self?.onTapBuyButton?(product)
        }
        
        cell.onSelectProduct = { [weak self] product in
            self?.onSelectProduct?(product)
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        typealias UIViewControllerType = UINavigationController
        
        func makeUIViewController(context: Context) -> UIViewControllerType {
            let viewModel = ShopViewModel()
            let viewController = ShopViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            
            return navController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif

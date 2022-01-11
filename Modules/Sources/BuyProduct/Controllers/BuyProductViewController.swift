import UIKit
import Combine
import Core

public class BuyProductViewController: UIViewController {
    
    private var viewModel: BuyProductViewModel
    
    private var anyCancellable = Set<AnyCancellable>()
    
    public var onTapSelectButton: ((ProductOption, Finish?) -> Void)?
    
    // MARK: - Views
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorInset = .zero
        tableView.allowsSelection = false

        tableView.register(HeroTableViewCell.self, forCellReuseIdentifier: HeroTableViewCell.identifier)
        tableView.register(ProductOptionTableViewCell.self, forCellReuseIdentifier: ProductOptionTableViewCell.identifier)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tintColor = .systemGray
        return indicator
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .title3, weight: .semibold)
        label.text = "This product has no options"
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializers
    
    public init(viewModel: BuyProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()

        title = viewModel.product.name

        view.backgroundColor = .systemGroupedBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Assing publishers
        viewModel.$productOptions
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
                    
                    if self?.viewModel.productOptions.isEmpty == true {
                        self?.tableView.backgroundView = self?.emptyLabel
                    }
                }
            }
            .store(in: &anyCancellable)
        
        fetchProductOptions()
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
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func fetchProductOptions() {
        viewModel.fetchFamilies()
    }
    
}

extension BuyProductViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.isLoading || (!viewModel.isLoading && viewModel.productOptions.isEmpty) {
            return 0
        }
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.productOptions.count
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.identifier, for: indexPath) as? HeroTableViewCell else {
                return UITableViewCell()
            }
            
            let viewModel = HeroViewModel(
                product: viewModel.product
            )
            cell.configure(with: viewModel)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductOptionTableViewCell.identifier, for: indexPath) as? ProductOptionTableViewCell else {
                return UITableViewCell()
            }
            
            let viewModel = ProductOptionViewModel(
                productOption: viewModel.productOptions[indexPath.row]
            )
            cell.configure(with: viewModel)
            
            cell.onTapSelectButton = { [weak self] productOption in
                self?.onTapSelectButton?(productOption, viewModel.selectedFinish)
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

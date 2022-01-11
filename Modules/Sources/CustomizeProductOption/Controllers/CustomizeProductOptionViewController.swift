import UIKit
import Combine
import Core

public class CustomizeProductOptionViewController: UIViewController {
    
    private var viewModel: CustomizeProductViewModel
    
    private var anyCancellable = Set<AnyCancellable>()
    
    // MARK: - Views
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.allowsMultipleSelection = true
        
        tableView.register(HeroTableViewCell.self, forCellReuseIdentifier: HeroTableViewCell.identifier)
        tableView.register(CustomizationItemTableViewCell.self, forCellReuseIdentifier: CustomizationItemTableViewCell.identifier)
        
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
        label.text = "This product option has no customizations"
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
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
    
    private let finalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .body, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.numberStyle = .currency
        return formatter
    }()
    
    // MARK: - Initializers
    
    public init(viewModel: CustomizeProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        setupTableViewTopSpace()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Assing publishers
        viewModel.$customizations
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
                    
                    if self?.viewModel.customizations.isEmpty == true {
                        self?.tableView.backgroundView = self?.emptyLabel
                    }
                }
            }
            .store(in: &anyCancellable)
        
        viewModel.$finalPrice
            .map { [weak self] price in
                return self?.numberFormatter.string(from: NSNumber(value: price)) ?? "\(price)"
            }
            .assign(to: \.text, on: finalPriceLabel)
            .store(in: &anyCancellable)
        
        fetchProductOptionCustomizations()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset.bottom = bottomView.bounds.height
        tableView.verticalScrollIndicatorInsets.bottom = bottomView.bounds.height
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
        
        bottomView.contentView.addSubview(finalPriceLabel)
        
        NSLayoutConstraint.activate([
            finalPriceLabel.topAnchor.constraint(equalTo: bottomView.contentView.topAnchor, constant: 10),
            finalPriceLabel.leadingAnchor.constraint(equalTo: bottomView.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            finalPriceLabel.trailingAnchor.constraint(equalTo: bottomView.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        bottomView.contentView.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: finalPriceLabel.bottomAnchor, constant: 12),
            addToCartButton.leadingAnchor.constraint(equalTo: bottomView.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: bottomView.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addToCartButton.bottomAnchor.constraint(equalTo: bottomView.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Functions
    
    private func setupTableViewTopSpace() {
        var frame: CGRect = .zero
        frame.size.height = .leastNormalMagnitude
        let headerView = UIView(frame: frame)
        tableView.tableHeaderView = headerView
    }
    
    private func fetchProductOptionCustomizations() {
        viewModel.fetchCustomizations()
    }
    
}

extension CustomizeProductOptionViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.isLoading || (!viewModel.isLoading && viewModel.customizations.isEmpty) {
            return 0
        }
        return 1 + viewModel.customizations.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return viewModel.customizations[section - 1].items.count
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        default:
            let customization = viewModel.customizations[section - 1]
            return customization.name
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.identifier, for: indexPath) as? HeroTableViewCell else {
                return UITableViewCell()
            }
            
            let viewModel = HeroViewModel(
                selectedProduct: viewModel.selectedProduct,
                selectedProductOption: viewModel.selectedProductOption,
                selectedFinish: viewModel.selectedFinish
            )
            
            cell.configure(with: viewModel)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomizationItemTableViewCell.identifier, for: indexPath) as? CustomizationItemTableViewCell else {
                return UITableViewCell()
            }
            
            let customization = viewModel.customizations[indexPath.section - 1]
            let item = customization.items[indexPath.row]
            
            let viewModel = CustomizationItemViewModel(
                item: item,
                priceChangeMethod: customization.priceChangeMethod
            )
            
            cell.configure(with: viewModel)
            
            if let selected = self.viewModel.selectedCustomizations[customization] {
                if selected == item {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
            } else {
                if indexPath.row == 0 {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
            
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        for ip in tableView.indexPathsForSelectedRows ?? [] {
            if ip.section == indexPath.section {
                tableView.deselectRow(at: ip, animated: true)
            }
        }
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let customization = viewModel.customizations[indexPath.section - 1]
            let item = customization.items[indexPath.row]

            viewModel.addCustomization(customization, item: item)
        }
    }
    
}

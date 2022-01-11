import UIKit
import Combine
import SDWebImage
import Core

public class ProductOptionTableViewCell: UITableViewCell {
    
    public static let identifier = "ProductOptionTableViewCell"
    
    private var viewModel: ProductOptionViewModel!
    
    private var anyCancellable = Set<AnyCancellable>()
    
    public var onTapSelectButton: ((ProductOption) -> Void)?
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let finishesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 35, height: 35)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(FinishCollectionViewCell.self, forCellWithReuseIdentifier: FinishCollectionViewCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .title3, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let specsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .subheadline, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .subheadline, weight: .regular)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton(type: .system)
        
        let title = "Select"
        
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
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.numberStyle = .currency
        return formatter
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        finishesCollectionView.delegate = self
        finishesCollectionView.dataSource = self
        contentView.addSubview(finishesCollectionView)
        
        selectButton.addTarget(self, action: #selector(selectButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(selectButton)
        NSLayoutConstraint.activate([
            selectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            selectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            selectButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.bottomAnchor.constraint(equalTo: selectButton.topAnchor, constant: -12)
        ])
        
        contentView.addSubview(specsLabel)
        NSLayoutConstraint.activate([
            specsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            specsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            specsLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -16)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: specsLabel.topAnchor, constant: -8)
        ])
        
        contentView.addSubview(finishesCollectionView)
        
        NSLayoutConstraint.activate([
            finishesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            finishesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            finishesCollectionView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -16),
            finishesCollectionView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        contentView.addSubview(productImageView)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: finishesCollectionView.topAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Functions
    
    public func configure(with viewModel: ProductOptionViewModel) {
        self.viewModel = viewModel
        
        nameLabel.text = viewModel.productOption.name.replacingOccurrences(of: "\\n", with: "\n")
        
        specsLabel.text = viewModel.productOption.specs.joined(separator: "\n")
        
        if let strPrice = numberFormatter.string(from: NSNumber(value: viewModel.productOption.price)) {
            priceLabel.text = strPrice
        } else {
            priceLabel.text = "No price available"
        }
        
        if let urlString = viewModel.productOption.imageURL {
            productImageView.sd_setImage(with: URL(string: urlString), completed: nil)
        }
        
        viewModel.$selectedFinish
            .sink { [weak self] finish in
                guard let imageURL = finish?.imageURL else { return }
                self?.productImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
            }
            .store(in: &anyCancellable)
    }
    
    // MARK: - Actions
    
    @objc private func selectButtonTapped(_ sender: UIButton) {
        onTapSelectButton?(viewModel.productOption)
    }
}

extension ProductOptionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productOption.availableFinishes?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinishCollectionViewCell.identifier, for: indexPath) as? FinishCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let finish = viewModel.productOption.availableFinishes?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        let viewModel = FinishViewModel(
            finish: finish
        )
        cell.configure(with: viewModel)
        
        if let selected = self.viewModel.selectedFinish {
            if selected.id == finish.id {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        } else {
            if indexPath.item == 0 {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let finish = viewModel.productOption.availableFinishes?[indexPath.item] else { return }
        viewModel.selectedFinish = finish
    }
}

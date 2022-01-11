import UIKit
import Core
import SDWebImage

public class ProductCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "ProductCollectionViewCell"
    
    private var viewModel: ProductCollectionViewCellViewModel!
    
    var onTapBuyButton: ((Product) -> Void)?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        
        let verticalInsets: CGFloat = 4
        let horizontalInsets: CGFloat = 12
        
        let title = "Buy"
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.title = title
            configuration.contentInsets = NSDirectionalEdgeInsets(top: verticalInsets, leading: horizontalInsets, bottom: verticalInsets, trailing: horizontalInsets)
            configuration.baseBackgroundColor = .systemBlue
            configuration.baseForegroundColor = .white
            configuration.cornerStyle = .capsule
            button.configuration = configuration
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
            button.setTitle(title, for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = button.bounds.height / 2
            button.clipsToBounds = true
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var labelsStackView: UIStackView!
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.numberStyle = .currency
        return formatter
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemGroupedBackground
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        buyButton.addTarget(self, action: #selector(buyButtonTapped(_:)), for: .touchUpInside)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(buyButton)
        
        labelsStackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 4
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelsStackView)
        
        applyConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Functions
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            buyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            buyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelsStackView.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: labelsStackView.topAnchor, constant: -16)
        ])
        
    }
    
    public func configure(with viewModel: ProductCollectionViewCellViewModel) {
        self.viewModel = viewModel
        
        nameLabel.text = viewModel.product.name
        
        if let strPrice = numberFormatter.string(from: NSNumber(value: viewModel.product.startingPrice)) {
            priceLabel.text = "Starts at \(strPrice)"
        } else {
            priceLabel.text = "No price available"
        }
        
        guard let urlString = viewModel.product.imageURL, let url = URL(string: urlString) else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }
    
    // MARK: - Actions
    
    @objc private func buyButtonTapped(_ sender: UIButton) {
        onTapBuyButton?(viewModel.product)
    }
    
}

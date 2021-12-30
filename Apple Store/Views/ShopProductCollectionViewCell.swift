//
//  ShopProductCollectionViewCell.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import UIKit
import SDWebImage

class ShopProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ShopProductCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAsp   ectFit
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
    
    private var labelsStackView: UIStackView!
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                let scale: CGFloat = 0.95
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: scale, y: scale) : .identity
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemGroupedBackground
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
        
        labelsStackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 4
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelsStackView)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -16)
        ])
        
    }
    
    func configure(with model: Product) {
        nameLabel.text = model.name
        priceLabel.text = "Starts at $\(model.startingPrice)"
        
        guard let urlString = model.imageURL, let url = URL(string: urlString) else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }
    
}

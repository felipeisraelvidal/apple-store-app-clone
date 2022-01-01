//
//  BuyProductOptionTableViewCell.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import UIKit

class BuyProductOptionTableViewCell: UITableViewCell {
    
    static let identifier = "BuyProductOptionTableViewCell"
    
    private var productOption: Product.Option!
    
    var onTapSelectButton: ((Product.Option) -> Void)?
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    private let finishSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        finishSegmentedControl.addTarget(self, action: #selector(finishSegmentedControlChanged(_:)), for: .valueChanged)
        contentView.addSubview(finishSegmentedControl)
        
        NSLayoutConstraint.activate([
            finishSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            finishSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            finishSegmentedControl.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -24)
        ])
        
        contentView.addSubview(productImageView)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: finishSegmentedControl.topAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with model: Product.Option) {
        self.productOption = model
        
        nameLabel.text = model.name
        specsLabel.text = model.specs?.joined(separator: "\n") ?? ""
        
        priceLabel.text = "$\(model.price ?? 0)"
        
        if let finishes = model.availableFinishes, !finishes.isEmpty {
            var index = 0
            for finish in finishes {
                finishSegmentedControl.insertSegment(withTitle: finish.name, at: index, animated: false)
                index += 1
            }
            finishSegmentedControl.selectedSegmentIndex = 0
        } else {
            finishSegmentedControl.isEnabled = false
        }
        
        if let urlString = model.imageURL {
            productImageView.sd_setImage(with: URL(string: urlString), completed: nil)
        }
        
    }
    
    @objc private func finishSegmentedControlChanged(_ sender: UISegmentedControl) {
        guard let finish = productOption.availableFinishes?[sender.selectedSegmentIndex], let urlString = finish.imageURL else { return }
        productImageView.sd_setImage(with: URL(string: urlString), completed: nil)
    }
    
    @objc private func selectButtonTapped(_ sender: UIButton) {
        onTapSelectButton?(productOption)
    }

}

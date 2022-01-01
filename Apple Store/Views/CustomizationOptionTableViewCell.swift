//
//  CustomizationOptionTableViewCell.swift
//  Apple Store
//
//  Created by Felipe Vidal on 31/12/21.
//

import UIKit

class CustomizationOptionTableViewCell: UITableViewCell {
    
    static let identifier = "CustomizationOptionTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .body, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var labelsStackView: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        labelsStackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 8
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelsStackView)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
    }
    
    func configure(with model: Product.Customization.Option) {
        nameLabel.text = model.name
        
        switch model.priceChangeMethod {
        case .sumBasePrice:
            priceLabel.text = "[+ $\(model.price)]"
        case .change_base_price:
            priceLabel.text = "Starts with $\(model.price)"
        default:
            break
        }
        
        if model.price == 0 {
            labelsStackView.removeArrangedSubview(priceLabel)
            priceLabel.removeFromSuperview()
        }
    }

}

//
//  ShopProductFamilySectionHeader.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import UIKit

class ShopProductFamilySectionHeader: UITableViewHeaderFooterView {

    static let identifier = "ShopProductFamilySectionHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .title2, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
    }
    
    func configure(with model: ProductFamily) {
        titleLabel.text = model.name
    }

}

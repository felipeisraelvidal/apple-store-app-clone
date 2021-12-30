//
//  ProductFamilyCollectionTableViewCell.swift
//  Apple Store
//
//  Created by Felipe Vidal on 29/12/21.
//

import UIKit
import Combine

class ProductFamilyCollectionTableViewCell: UITableViewCell {
    
    static let identifier = "ProductFamilyCollectionTableViewCell"
    
    private var anyCancellable = Set<AnyCancellable>()
    private let viewModel = ProductFamilyViewModel()
    
    var onSelectModel: ((ProductModel) -> Void)?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 250)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(ProductModelCollectionViewCell.self, forCellWithReuseIdentifier: ProductModelCollectionViewCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemGroupedBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    func configureCell(with model: ProductFamily) {
        viewModel.fetchModels(for: model)
        viewModel.$models
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &anyCancellable)
    }

}

extension ProductFamilyCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductModelCollectionViewCell.identifier, for: indexPath) as? ProductModelCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: viewModel.models[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onSelectModel?(viewModel.models[indexPath.row])
    }
    
}

//
//  ProductDetailsViewController.swift
//  Apple Store
//
//  Created by Felipe Vidal on 30/12/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    weak var coordinator: ShopCoordinator?
    
    private var viewModel: ProductDetailsViewModel
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        
        let symbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.preferredFont(for: .footnote, weight: .heavy))
        let image = UIImage(systemName: "xmark", withConfiguration: symbolConfiguration)
        
        let verticalInsets: CGFloat = 8
        let horizontalInsets: CGFloat = 8
        
        let backgroundColor: UIColor = .secondaryLabel
        let foregroundColor: UIColor = .white
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.image = image
            configuration.contentInsets = NSDirectionalEdgeInsets(top: verticalInsets, leading: horizontalInsets, bottom: verticalInsets, trailing: horizontalInsets)
            configuration.baseBackgroundColor = backgroundColor
            configuration.baseForegroundColor = foregroundColor
            configuration.cornerStyle = .capsule
            button.configuration = configuration
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
            button.setImage(image, for: .normal)
            button.backgroundColor = backgroundColor
            button.setTitleColor(foregroundColor, for: .normal)
            button.layer.cornerRadius = button.bounds.height / 2
            button.clipsToBounds = true
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(viewModel: ProductDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        configureNavigationBar()
        
        title = viewModel.selectedProduct.name
        
        view.backgroundColor = .systemBackground
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        
        if let urlString = viewModel.selectedProduct.imageURL {
            posterImageView.sd_setImage(with: URL(string: urlString), completed: nil)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        coordinator?.dismiss(self)
    }

}

#if DEBUG
import SwiftUI

struct ProductDetailsViewControllerPreviews: PreviewProvider {
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            ContainerPreview()
                .ignoresSafeArea()
                .environment(\.colorScheme, scheme)
        }
    }
    
    struct ContainerPreview: UIViewControllerRepresentable {
        typealias UIViewControllerType = UINavigationController
        
        func makeUIViewController(context: Context) -> UIViewControllerType {
            let product = Product(
                id: 0,
                name: "MacBook Pro 16\"",
                imageURL: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mac-card-40-macbook-pro-16-202110?wid=1200&hei=1000&fmt=p-jpg&qlt=95&.v=1633726244000",
                availableColors: [
                    "space_gray",
                    "gold",
                    "silver"
                ],
                startingPrice: 2499,
                family: .init(
                    id: 0,
                    name: "Mac",
                    imageURL: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/store-card-mac-nav-202110?wid=400&hei=260&fmt=png-alpha&.v=1632870674000"
                )
            )
            let viewModel = ProductDetailsViewModel(selectedProduct: product)
            let viewController = ProductDetailsViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            
            return navController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
#endif

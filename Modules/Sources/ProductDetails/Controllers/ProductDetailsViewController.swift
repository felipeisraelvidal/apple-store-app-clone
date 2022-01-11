import UIKit
import SDWebImage

public class ProductDetailsViewController: UIViewController {
    
    private var viewModel: ProductDetailsViewModel
    
    public var onTapCloseButton: (() -> Void)?
    
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
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public init(viewModel: ProductDetailsViewModel) {
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
        
        view.backgroundColor = .systemBackground
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        
        if let urlString = viewModel.product.imageURL {
            posterImageView.sd_setImage(with: URL(string: urlString), completed: nil)
        }
    }
    
    public override func loadView() {
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
    
    // MARK: - Functions
    
    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        onTapCloseButton?()
    }
    
}

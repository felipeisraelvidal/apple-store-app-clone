import UIKit
import SDWebImage

public class FinishCollectionViewCell: UICollectionViewCell {
    public static let identifier = "FinishCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
            layer.borderWidth = isSelected ? 3 : 0
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with viewModel: FinishViewModel) {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
        
        imageView.sd_setImage(with: URL(string: viewModel.finish.iconImageURL), completed: nil)
    }
}

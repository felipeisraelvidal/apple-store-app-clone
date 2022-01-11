import UIKit
import SDWebImage

public class HeroTableViewCell: UITableViewCell {
    
    static let identifier = "HeroTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .title1, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .secondarySystemGroupedBackground
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(heroImageView)
        
        applyConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews where view != contentView {
            view.removeFromSuperview()
        }
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = .secondarySystemGroupedBackground
//
//        insetsLayoutMarginsFromSafeArea = true
//
//        addSubview(titleLabel)
//        addSubview(imageView)
//
//        applyConstraints()
//    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            heroImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            heroImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
    }
    
    func configure(with viewModel: HeroViewModel) {
        if let selectedFinish = viewModel.selectedFinish {
            titleLabel.text = "Customize your new \(viewModel.selectedProduct.model.name) – \(selectedFinish.name)"
        } else {
            titleLabel.text = "Customize your new \(viewModel.selectedProduct.model.name)"
        }
        
        if let imageURL = viewModel.selectedFinish?.imageURL {
            heroImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        } else {
            guard let urlString = viewModel.selectedProductOption.imageURL else { return }
            heroImageView.sd_setImage(with: URL(string: urlString), completed: nil)
        }
    }
    
}

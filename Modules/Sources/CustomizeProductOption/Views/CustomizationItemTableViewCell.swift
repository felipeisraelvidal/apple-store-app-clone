import UIKit

public class CustomizationItemTableViewCell: UITableViewCell {
    
    public static let identifier = "CustomizationItemTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
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

    public override func setSelected(_ selected: Bool, animated: Bool) {
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
    
    func configure(with viewModel: CustomizationItemViewModel) {
        nameLabel.text = viewModel.item.name
        
        switch viewModel.priceChangeMethod {
        case .sumBasePrice:
            priceLabel.text = "[+ $\(viewModel.item.price ?? 0)]"
        case .changeBasePrice:
            priceLabel.text = "Starts with $\(viewModel.item.price ?? 0)"
        default:
            break
        }
        
        if viewModel.item.price == nil {
            labelsStackView.removeArrangedSubview(priceLabel)
            priceLabel.removeFromSuperview()
        }
    }
    
}

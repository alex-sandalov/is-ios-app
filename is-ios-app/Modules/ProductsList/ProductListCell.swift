import UIKit

final class ProductListCell: UITableViewCell {
    static let reuseIdentifier = "ProductListCell"

    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var amountLabel = UILabel()
    private var statusLabel = UILabel()
    private var textContainerStackView = UIStackView()
    private var rightContainerStackView = UIStackView()
    private var rootStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        subtitleLabel.text = nil
        amountLabel.text = nil
        statusLabel.text = nil
    }

    func configure(with viewModel: ProductListItem) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        amountLabel.text = viewModel.amountText
        statusLabel.text = viewModel.statusText
        subtitleLabel.isHidden = viewModel.subtitle == nil
    }

    private func setupAppearance() {
        selectionStyle = .default
        accessoryType = .disclosureIndicator

        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountLabel.textColor = .systemBlue
        amountLabel.textAlignment = .right
        amountLabel.numberOfLines = 1

        statusLabel.font = .systemFont(ofSize: 13, weight: .medium)
        statusLabel.textColor = .systemBlue
        statusLabel.textAlignment = .right
        statusLabel.numberOfLines = 1
        statusLabel.backgroundColor = .systemBlue.withAlphaComponent(0.08)
        statusLabel.layer.cornerRadius = 8
        statusLabel.layer.masksToBounds = true

        textContainerStackView.axis = .vertical
        textContainerStackView.spacing = 4
        textContainerStackView.alignment = .fill
        textContainerStackView.distribution = .fill

        rightContainerStackView.axis = .vertical
        rightContainerStackView.spacing = 6
        rightContainerStackView.alignment = .trailing
        rightContainerStackView.distribution = .fill

        rootStackView.axis = .horizontal
        rootStackView.spacing = 12
        rootStackView.alignment = .center
        rootStackView.distribution = .fill
    }

    private func setupHierarchy() {
        textContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        rightContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.translatesAutoresizingMaskIntoConstraints = false

        textContainerStackView.addArrangedSubview(titleLabel)
        textContainerStackView.addArrangedSubview(subtitleLabel)

        rightContainerStackView.addArrangedSubview(amountLabel)
        rightContainerStackView.addArrangedSubview(statusLabel)

        rootStackView.addArrangedSubview(textContainerStackView)
        rootStackView.addArrangedSubview(rightContainerStackView)

        contentView.addSubview(rootStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            rightContainerStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            statusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24)
        ])
    }
}

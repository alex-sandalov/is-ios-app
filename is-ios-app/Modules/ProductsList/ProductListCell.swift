import UIKit

final class ProductListCell: UITableViewCell {
    static let reuseIdentifier = "ProductListCell"

    private var cardView = DSCardView()
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var amountLabel = UILabel()
    private var statusLabel = UILabel()

    private var textStackView = UIStackView()
    private var rightStackView = UIStackView()
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

    func configure(with config: ProductListCellConfig) {
        titleLabel.text = config.titleText
        subtitleLabel.text = config.subtitleText
        amountLabel.text = config.amountText
        statusLabel.text = config.statusText
        subtitleLabel.isHidden = config.subtitleText == nil
    }

    private func setupAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        titleLabel.apply(.body)
        titleLabel.font = DS.Typography.bodySemibold()

        subtitleLabel.apply(.captionSecondary)
        subtitleLabel.numberOfLines = 1

        amountLabel.apply(.bodyAccent)
        amountLabel.textAlignment = .right

        statusLabel.apply(.captionSecondary)
        statusLabel.textAlignment = .right

        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.spacing = DS.Spacing.xxs
        textStackView.alignment = .fill

        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.axis = .vertical
        rightStackView.spacing = DS.Spacing.xxs
        rightStackView.alignment = .trailing

        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .horizontal
        rootStackView.spacing = DS.Spacing.s
        rootStackView.alignment = .center
    }

    private func setupHierarchy() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)

        rightStackView.addArrangedSubview(amountLabel)
        rightStackView.addArrangedSubview(statusLabel)

        rootStackView.addArrangedSubview(textStackView)
        rootStackView.addArrangedSubview(rightStackView)

        contentView.addSubview(cardView)
        cardView.addSubview(rootStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.xs),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.m),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.m),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.xs),

            rootStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DS.Spacing.s),
            rootStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DS.Spacing.m),
            rootStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DS.Spacing.m),
            rootStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DS.Spacing.s),

            rightStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 90)
        ])
    }
}

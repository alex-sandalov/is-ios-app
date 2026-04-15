import UIKit

final class DSStateView: UIView {
    struct Config {
        enum Style {
            case hidden
            case loading
            case empty
            case error
        }

        let style: Style
        let title: String?
        let message: String?
        let actionTitle: String?
    }

    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var titleLabel = UILabel()
    private var messageLabel = UILabel()
    private var actionButton = DSButton()
    private var stackView = UIStackView()

    var onActionTap: (() -> Void)?

    init() {
        super.init(frame: .zero)
        setupAppearance()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func configure(with config: Config) {
        switch config.style {
        case .hidden:
            isHidden = true
            activityIndicator.stopAnimating()
            actionButton.isHidden = true

        case .loading:
            isHidden = false
            titleLabel.text = config.title
            messageLabel.text = config.message
            messageLabel.isHidden = config.message == nil
            activityIndicator.startAnimating()
            actionButton.isHidden = true

        case .empty:
            isHidden = false
            titleLabel.text = config.title
            messageLabel.text = config.message
            messageLabel.isHidden = config.message == nil
            activityIndicator.stopAnimating()
            actionButton.isHidden = true

        case .error:
            isHidden = false
            titleLabel.text = config.title
            messageLabel.text = config.message
            messageLabel.isHidden = config.message == nil
            activityIndicator.stopAnimating()

            if let actionTitle = config.actionTitle {
                actionButton.isHidden = false
                actionButton.configure(
                    with: .init(
                        title: actionTitle,
                        style: .primary,
                        isEnabled: true
                    )
                )
            } else {
                actionButton.isHidden = true
            }
        }
    }

    private func setupAppearance() {
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = DS.Colors.primary
        activityIndicator.hidesWhenStopped = true

        titleLabel.apply(.title)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.apply(.bodySecondary)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        actionButton.isHidden = true
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DS.Spacing.s
        stackView.alignment = .center
    }

    private func setupHierarchy() {
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(actionButton)

        addSubview(stackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.l),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.l),

            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
    }

    @objc
    private func didTapAction() {
        onActionTap?()
    }
}

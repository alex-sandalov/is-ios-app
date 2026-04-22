import UIKit

@MainActor
final class LoadingNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .loading

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard case .loading(let content)? = node.content else { return nil }

        let container = BDUIContainerView()
        container.configure(
            backgroundColorToken: .clear,
            padding: .m,
            cornerRadius: nil
        )

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DS.Spacing.s
        stackView.alignment = .center

        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()

        stackView.addArrangedSubview(indicator)

        if let title = content.title, !title.isEmpty {
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.apply(.title)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.text = title
            stackView.addArrangedSubview(titleLabel)
        }

        if let message = content.message, !message.isEmpty {
            let messageLabel = UILabel()
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.apply(.bodySecondary)
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.text = message
            stackView.addArrangedSubview(messageLabel)
        }

        container.contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.contentView.bottomAnchor)
        ])

        return container
    }
}

import UIKit

@MainActor
final class EmptyNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .empty

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard case .empty(let content)? = node.content else { return nil }

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

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.apply(.title)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = content.title

        stackView.addArrangedSubview(titleLabel)

        if let subtitle = content.subtitle, !subtitle.isEmpty {
            let subtitleLabel = UILabel()
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            subtitleLabel.apply(.bodySecondary)
            subtitleLabel.textAlignment = .center
            subtitleLabel.numberOfLines = 0
            subtitleLabel.text = subtitle
            stackView.addArrangedSubview(subtitleLabel)
        }

        if let actionTitle = content.actionTitle, !actionTitle.isEmpty {
            let button = DSButton()
            button.configure(
                with: .init(
                    title: actionTitle,
                    style: .primary,
                    isEnabled: true
                )
            )

            context.bindAction(node.action, to: button)
            stackView.addArrangedSubview(button)
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

import UIKit

@MainActor
final class ContainerNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .container

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard case .container(let content)? = node.content else { return nil }

        let container = BDUIContainerView()
        container.configure(
            backgroundColorToken: content.backgroundColor,
            padding: content.padding,
            cornerRadius: content.cornerRadius
        )

        let childViews = context.mapChildren(node.subviews)

        let host = UIStackView()
        host.translatesAutoresizingMaskIntoConstraints = false
        host.axis = .vertical
        host.spacing = 0

        childViews.forEach { child in
            host.addArrangedSubview(child)
        }

        container.contentView.addSubview(host)

        NSLayoutConstraint.activate([
            host.topAnchor.constraint(equalTo: container.contentView.topAnchor),
            host.leadingAnchor.constraint(equalTo: container.contentView.leadingAnchor),
            host.trailingAnchor.constraint(equalTo: container.contentView.trailingAnchor),
            host.bottomAnchor.constraint(equalTo: container.contentView.bottomAnchor)
        ])

        return container
    }
}

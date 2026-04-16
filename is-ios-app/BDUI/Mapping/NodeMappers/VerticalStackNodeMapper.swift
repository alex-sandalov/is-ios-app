import UIKit

@MainActor
final class VerticalStackNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .vStack

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard case .stack(let content)? = node.content else { return nil }

        let childViews = context.mapChildren(node.subviews)

        if content.padding != nil || content.backgroundColor != nil {
            let container = BDUIContainerView()
            container.configure(
                backgroundColorToken: content.backgroundColor,
                padding: content.padding,
                cornerRadius: nil
            )

            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = content.spacing?.value ?? 0

            childViews.forEach { child in
                stackView.addArrangedSubview(child)
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

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = content.spacing?.value ?? 0
        stackView.backgroundColor = content.backgroundColor?.uiColor

        childViews.forEach { child in
            stackView.addArrangedSubview(child)
        }

        return stackView
    }
}

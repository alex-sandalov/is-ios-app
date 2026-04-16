import UIKit

@MainActor
final class CardNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .card

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard case .card(let content)? = node.content else { return nil }

        let view = BDUICardContainerView()
        view.configure(
            backgroundColorToken: content.backgroundColor,
            padding: content.padding
        )

        let childViews = context.mapChildren(node.subviews)
        childViews.forEach { child in
            view.addContentSubview(child)
        }

        return view
    }
}

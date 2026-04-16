import UIKit

@MainActor
final class ScrollNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .scroll

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard case .scroll(let content)? = node.content else { return nil }

        let view = BDUIScrollContainerView()
        view.configure(
            spacing: content.spacing,
            padding: content.padding,
            backgroundColorToken: content.backgroundColor
        )

        let childViews = context.mapChildren(node.subviews)
        childViews.forEach { child in
            view.addContentSubview(child)
        }

        return view
    }
}

import UIKit

@MainActor
final class ButtonNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .button

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard case .button(let content)? = node.content else { return nil }

        let button = DSButton()
        button.configure(
            with: .init(
                title: content.title,
                style: content.style.dsStyle,
                isEnabled: content.isEnabled ?? true
            )
        )

        context.bindAction(node.action, to: button)
        return button
    }
}

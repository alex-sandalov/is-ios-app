import UIKit

@MainActor
final class DividerNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .divider

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false

        if case .divider(let content)? = node.content {
            divider.backgroundColor = content.color?.uiColor ?? DS.Colors.border
            NSLayoutConstraint.activate([
                divider.heightAnchor.constraint(equalToConstant: CGFloat(content.thickness ?? 1))
            ])
        } else {
            divider.backgroundColor = DS.Colors.border
            NSLayoutConstraint.activate([
                divider.heightAnchor.constraint(equalToConstant: 1)
            ])
        }

        return divider
    }
}

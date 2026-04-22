import UIKit

@MainActor
final class SpacerNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .spacer

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        if case .spacer(let content)? = node.content {
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: CGFloat(content.height ?? 16))
            ])
        } else {
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 16)
            ])
        }

        return view
    }
}

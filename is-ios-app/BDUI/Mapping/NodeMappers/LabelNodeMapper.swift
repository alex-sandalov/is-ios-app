import UIKit

@MainActor
final class LabelNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .label

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard case .label(let content)? = node.content else { return nil }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = content.text
        label.apply(content.textStyle.textStyle)
        label.textColor = content.color?.uiColor ?? label.textColor
        label.numberOfLines = content.numberOfLines ?? 0

        switch content.alignment {
        case "center":
            label.textAlignment = .center
        case "right":
            label.textAlignment = .right
        default:
            label.textAlignment = .left
        }

        return label
    }
}

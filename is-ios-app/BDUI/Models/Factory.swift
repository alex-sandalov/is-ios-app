import Foundation

extension BDUINodeDTO {
    static func makeRootScroll(
        id: String,
        children: [BDUINodeDTO]
    ) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .scroll,
            content: .scroll(
                BDUIScrollContentDTO(
                    spacing: .m,
                    padding: .m,
                    backgroundColor: .background
                )
            ),
            subviews: children,
            action: nil,
            isVisible: true
        )
    }

    static func makeVerticalStack(
        id: String,
        spacing: BDUISpacingToken,
        padding: BDUISpacingToken?,
        children: [BDUINodeDTO]
    ) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .vStack,
            content: .stack(
                BDUIStackContentDTO(
                    spacing: spacing,
                    padding: padding,
                    backgroundColor: .clear
                )
            ),
            subviews: children,
            action: nil,
            isVisible: true
        )
    }

    static func makeHorizontalStack(
        id: String,
        spacing: BDUISpacingToken,
        children: [BDUINodeDTO]
    ) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .hStack,
            content: .stack(
                BDUIStackContentDTO(
                    spacing: spacing,
                    padding: nil,
                    backgroundColor: .clear
                )
            ),
            subviews: children,
            action: nil,
            isVisible: true
        )
    }

    static func makeCard(
        id: String,
        children: [BDUINodeDTO]
    ) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .card,
            content: .card(
                BDUICardContentDTO(
                    padding: .m,
                    backgroundColor: .surface
                )
            ),
            subviews: children,
            action: nil,
            isVisible: true
        )
    }

    static func makeLabel(
        id: String,
        text: String,
        textStyle: BDUITextStyleToken,
        color: BDUIColorToken
    ) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .label,
            content: .label(
                BDUILabelContentDTO(
                    text: text,
                    textStyle: textStyle,
                    color: color,
                    alignment: "left",
                    numberOfLines: 0
                )
            ),
            subviews: [],
            action: nil,
            isVisible: true
        )
    }

    static func makeDivider(id: String) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .divider,
            content: .divider(
                BDUIDividerContentDTO(
                    color: .border,
                    thickness: 1
                )
            ),
            subviews: [],
            action: nil,
            isVisible: true
        )
    }

    static func makeEmpty(
        id: String,
        title: String,
        subtitle: String?,
        actionTitle: String?,
        action: BDUIActionDTO?
    ) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .empty,
            content: .empty(
                BDUIEmptyContentDTO(
                    title: title,
                    subtitle: subtitle,
                    actionTitle: actionTitle
                )
            ),
            subviews: [],
            action: action,
            isVisible: true
        )
    }

    static func makeFlexibleSpacer(id: String) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .spacer,
            content: .spacer(
                BDUISpacerContentDTO(height: 1)
            ),
            subviews: [],
            action: nil,
            isVisible: true
        )
    }

    static func makeSearchField(
        id: String,
        title: String,
        placeholder: String,
        text: String,
        action: BDUIActionDTO?
    ) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .textField,
            content: .textField(
                BDUITextFieldContentDTO(
                    placeholder: placeholder,
                    title: title,
                    text: text,
                    errorMessage: nil,
                    isSecure: false
                )
            ),
            subviews: [],
            action: action,
            isVisible: true
        )
    }

    static func makeBadge(
        id: String,
        text: String
    ) -> BDUINodeDTO {
        BDUINodeDTO(
            id: id,
            type: .container,
            content: .container(
                BDUIContainerContentDTO(
                    backgroundColor: .elevatedSurface,
                    padding: .xs,
                    cornerRadius: .m
                )
            ),
            subviews: [
                BDUINodeDTO.makeLabel(
                    id: "\(id)_label",
                    text: text,
                    textStyle: BDUITextStyleToken.captionSecondary,
                    color: BDUIColorToken.textSecondary
                )
            ],
            action: nil,
            isVisible: true
        )
    }
}

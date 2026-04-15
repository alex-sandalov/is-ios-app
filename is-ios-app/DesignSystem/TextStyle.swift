import UIKit

enum TextStyle {
    case largeTitle
    case title
    case body
    case bodySecondary
    case bodyAccent
    case caption
    case captionSecondary
    case error
}

extension UILabel {
    func apply(_ style: TextStyle) {
        switch style {
        case .largeTitle:
            font = DS.Typography.largeTitle()
            textColor = DS.Colors.textPrimary

        case .title:
            font = DS.Typography.title()
            textColor = DS.Colors.textPrimary

        case .body:
            font = DS.Typography.body()
            textColor = DS.Colors.textPrimary

        case .bodySecondary:
            font = DS.Typography.body()
            textColor = DS.Colors.textSecondary

        case .bodyAccent:
            font = DS.Typography.bodySemibold()
            textColor = DS.Colors.primary

        case .caption:
            font = DS.Typography.caption()
            textColor = DS.Colors.textPrimary

        case .captionSecondary:
            font = DS.Typography.caption()
            textColor = DS.Colors.textSecondary

        case .error:
            font = DS.Typography.caption()
            textColor = DS.Colors.error
        }
    }
}

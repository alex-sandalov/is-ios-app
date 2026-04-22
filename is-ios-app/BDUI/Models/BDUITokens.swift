import UIKit

enum BDUIColorToken: String, Decodable {
    case background
    case surface
    case elevatedSurface
    case primary
    case textPrimary
    case textSecondary
    case border
    case error
    case success
    case clear

    var uiColor: UIColor {
        switch self {
        case .background: return DS.Colors.background
        case .surface: return DS.Colors.surface
        case .elevatedSurface: return DS.Colors.elevatedSurface
        case .primary: return DS.Colors.primary
        case .textPrimary: return DS.Colors.textPrimary
        case .textSecondary: return DS.Colors.textSecondary
        case .border: return DS.Colors.border
        case .error: return DS.Colors.error
        case .success: return DS.Colors.success
        case .clear: return .clear
        }
    }
}

enum BDUISpacingToken: String, Decodable {
    case xxs
    case xs
    case s
    case m
    case l
    case xl

    var value: CGFloat {
        switch self {
        case .xxs: return DS.Spacing.xxs
        case .xs: return DS.Spacing.xs
        case .s: return DS.Spacing.s
        case .m: return DS.Spacing.m
        case .l: return DS.Spacing.l
        case .xl: return DS.Spacing.xl
        }
    }
}

enum BDUICornerRadiusToken: String, Decodable {
    case s
    case m
    case l

    var value: CGFloat {
        switch self {
        case .s: return DS.CornerRadius.s
        case .m: return DS.CornerRadius.m
        case .l: return DS.CornerRadius.l
        }
    }
}

enum BDUITextStyleToken: String, Decodable {
    case largeTitle
    case title
    case body
    case bodySecondary
    case bodyAccent
    case caption
    case captionSecondary
    case error

    var textStyle: TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title
        case .body: return .body
        case .bodySecondary: return .bodySecondary
        case .bodyAccent: return .bodyAccent
        case .caption: return .caption
        case .captionSecondary: return .captionSecondary
        case .error: return .error
        }
    }
}

enum BDUIButtonStyleToken: String, Decodable {
    case primary
    case secondary

    var dsStyle: DSButton.Config.Style {
        switch self {
        case .primary: return .primary
        case .secondary: return .secondary
        }
    }
}

import UIKit

enum DS {
    enum Colors {
        static let background = UIColor.systemBackground
        static let surface = UIColor.secondarySystemBackground
        static let elevatedSurface = UIColor.tertiarySystemBackground
        static let primary = UIColor.systemBlue
        static let textPrimary = UIColor.label
        static let textSecondary = UIColor.secondaryLabel
        static let border = UIColor.separator
        static let error = UIColor.systemRed
        static let success = UIColor.systemGreen
    }

    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let s: CGFloat = 12
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 32
    }

    enum CornerRadius {
        static let s: CGFloat = 8
        static let m: CGFloat = 12
        static let l: CGFloat = 16
    }

    enum Typography {
        static func largeTitle() -> UIFont {
            .systemFont(ofSize: 28, weight: .bold)
        }

        static func title() -> UIFont {
            .systemFont(ofSize: 20, weight: .semibold)
        }

        static func body() -> UIFont {
            .systemFont(ofSize: 16, weight: .regular)
        }

        static func bodySemibold() -> UIFont {
            .systemFont(ofSize: 16, weight: .semibold)
        }

        static func caption() -> UIFont {
            .systemFont(ofSize: 13, weight: .regular)
        }

        static func captionSemibold() -> UIFont {
            .systemFont(ofSize: 13, weight: .semibold)
        }
    }
}

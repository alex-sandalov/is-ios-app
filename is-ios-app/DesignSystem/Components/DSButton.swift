import UIKit

final class DSButton: UIButton {
    struct Config {
        enum Style {
            case primary
            case secondary
        }

        let title: String
        let style: Style
        let isEnabled: Bool
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseAppearance()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func configure(with config: Config) {
        setTitle(config.title, for: .normal)
        isEnabled = config.isEnabled

        switch config.style {
        case .primary:
            backgroundColor = DS.Colors.primary
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
            layer.borderColor = nil

        case .secondary:
            backgroundColor = DS.Colors.surface
            setTitleColor(DS.Colors.primary, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = DS.Colors.primary.cgColor
        }

        alpha = config.isEnabled ? 1.0 : 0.5
    }

    private func setupBaseAppearance() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = DS.Typography.bodySemibold()
        layer.cornerRadius = DS.CornerRadius.m
        layer.masksToBounds = true
    }
}

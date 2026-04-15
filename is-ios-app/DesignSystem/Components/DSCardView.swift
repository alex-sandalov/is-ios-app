import UIKit

final class DSCardView: UIView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = DS.Colors.surface
        layer.cornerRadius = DS.CornerRadius.l
        layer.borderWidth = 1
        layer.borderColor = DS.Colors.border.cgColor
    }

    required init?(coder: NSCoder) {
        nil
    }
}

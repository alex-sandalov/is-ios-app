import UIKit

final class BDUIContainerView: UIView {
    var contentView = UIView()

    private var topConstraint = NSLayoutConstraint()
    private var leadingConstraint = NSLayoutConstraint()
    private var trailingConstraint = NSLayoutConstraint()
    private var bottomConstraint = NSLayoutConstraint()

    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentView)

        topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        leadingConstraint = contentView.leadingAnchor.constraint(equalTo: leadingAnchor)
        trailingConstraint = contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            bottomConstraint
        ])
    }

    required init?(coder: NSCoder) {
        nil
    }

    func configure(
        backgroundColorToken: BDUIColorToken?,
        padding: BDUISpacingToken?,
        cornerRadius: BDUICornerRadiusToken?
    ) {
        backgroundColor = backgroundColorToken?.uiColor ?? .clear
        layer.cornerRadius = cornerRadius?.value ?? 0
        clipsToBounds = true

        let inset = padding?.value ?? 0
        topConstraint.constant = inset
        leadingConstraint.constant = inset
        trailingConstraint.constant = -inset
        bottomConstraint.constant = -inset
    }
}

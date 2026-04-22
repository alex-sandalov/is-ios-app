import UIKit

final class BDUICardContainerView: UIView {
    var cardView = DSCardView()
    private var contentStackView = UIStackView()

    private var topConstraint = NSLayoutConstraint()
    private var leadingConstraint = NSLayoutConstraint()
    private var trailingConstraint = NSLayoutConstraint()
    private var bottomConstraint = NSLayoutConstraint()

    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 0

        addSubview(cardView)
        cardView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        topConstraint = contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DS.Spacing.m)
        leadingConstraint = contentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DS.Spacing.m)
        trailingConstraint = contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DS.Spacing.m)
        bottomConstraint = contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DS.Spacing.m)

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
        padding: BDUISpacingToken?
    ) {
        if let backgroundColorToken {
            cardView.backgroundColor = backgroundColorToken.uiColor
        }

        let inset = padding?.value ?? DS.Spacing.m
        topConstraint.constant = inset
        leadingConstraint.constant = inset
        trailingConstraint.constant = -inset
        bottomConstraint.constant = -inset
    }

    func addContentSubview(_ view: UIView) {
        contentStackView.addArrangedSubview(view)
    }
}

import UIKit

final class BDUIScrollContainerView: UIView {
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var stackView = UIStackView()

    private var topConstraint = NSLayoutConstraint()
    private var leadingConstraint = NSLayoutConstraint()
    private var trailingConstraint = NSLayoutConstraint()
    private var bottomConstraint = NSLayoutConstraint()

    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 0

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        topConstraint = stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        leadingConstraint = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        trailingConstraint = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        bottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

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
        spacing: BDUISpacingToken?,
        padding: BDUISpacingToken?,
        backgroundColorToken: BDUIColorToken?
    ) {
        backgroundColor = backgroundColorToken?.uiColor
        stackView.spacing = spacing?.value ?? 0

        let inset = padding?.value ?? 0
        topConstraint.constant = inset
        leadingConstraint.constant = inset
        trailingConstraint.constant = -inset
        bottomConstraint.constant = -inset
    }

    func addContentSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    func setKeyboardInset(_ bottomInset: CGFloat) {
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }

    func scrollToVisible(_ targetView: UIView, animated: Bool) {
        let rect = targetView.convert(targetView.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -24), animated: animated)
    }
}

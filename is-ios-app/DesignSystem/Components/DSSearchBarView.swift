import UIKit

@MainActor
protocol DSSearchBarViewDelegate: AnyObject {
    func didChangeSearchText(_ text: String?)
}

final class DSSearchBarView: UIView {
    struct Config {
        let placeholder: String
        let text: String?
    }

    weak var delegate: DSSearchBarViewDelegate?

    private var textField = UITextField()
    private var iconImageView = UIImageView()
    private var clearButton = UIButton(type: .system)
    private var containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func configure(with config: Config) {
        textField.placeholder = config.placeholder
        textField.text = config.text
        updateClearButtonVisibility()
    }

    func resignFocus() {
        textField.resignFirstResponder()
    }

    private func setupAppearance() {
        translatesAutoresizingMaskIntoConstraints = false

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = DS.Colors.elevatedSurface
        containerView.layer.cornerRadius = DS.CornerRadius.m
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = DS.Colors.border.cgColor

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(systemName: "magnifyingglass")
        iconImageView.tintColor = DS.Colors.textSecondary
        iconImageView.contentMode = .scaleAspectFit

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textColor = DS.Colors.textPrimary
        textField.font = DS.Typography.body()
        textField.clearButtonMode = .never
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = DS.Colors.textSecondary
        clearButton.isHidden = true
        clearButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
    }

    private func setupHierarchy() {
        addSubview(containerView)

        containerView.addSubview(iconImageView)
        containerView.addSubview(textField)
        containerView.addSubview(clearButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 44),

            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: DS.Spacing.m),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),

            clearButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -DS.Spacing.s),
            clearButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 28),
            clearButton.heightAnchor.constraint(equalToConstant: 28),

            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: DS.Spacing.s),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -DS.Spacing.xs),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    @objc
    private func textDidChange() {
        updateClearButtonVisibility()
        delegate?.didChangeSearchText(textField.text)
    }

    @objc
    private func didTapClear() {
        textField.text = nil
        updateClearButtonVisibility()
        delegate?.didChangeSearchText(nil)
    }

    private func updateClearButtonVisibility() {
        let hasText = !(textField.text ?? "").isEmpty
        clearButton.isHidden = !hasText
    }
}

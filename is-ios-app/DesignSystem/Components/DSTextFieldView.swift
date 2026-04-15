import UIKit

final class DSTextFieldView: UIView {
    struct Config {
        let title: String
        let placeholder: String
        let text: String?
        let errorMessage: String?
        let isSecure: Bool
        let keyboardType: UIKeyboardType
        let textContentType: UITextContentType?
        let returnKeyType: UIReturnKeyType
    }

    private var titleLabel = UILabel()
    private var errorLabel = UILabel()
    private var stackView = UIStackView()

    var textField = UITextField()

    var inputText: String {
        textField.text ?? ""
    }

    var delegate: UITextFieldDelegate? {
        get { textField.delegate }
        set { textField.delegate = newValue }
    }

    init() {
        super.init(frame: .zero)
        setupAppearance()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func configure(with config: Config) {
        titleLabel.text = config.title
        textField.placeholder = config.placeholder
        textField.text = config.text
        textField.isSecureTextEntry = config.isSecure
        textField.keyboardType = config.keyboardType
        textField.textContentType = config.textContentType
        textField.returnKeyType = config.returnKeyType

        errorLabel.text = config.errorMessage
        errorLabel.isHidden = config.errorMessage == nil
        textField.layer.borderColor = (config.errorMessage == nil ? DS.Colors.border : DS.Colors.error).cgColor
    }

    func focus() {
        textField.becomeFirstResponder()
    }

    func resignFocus() {
        textField.resignFirstResponder()
    }

    private func setupAppearance() {
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.apply(.captionSecondary)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = DS.Colors.elevatedSurface
        textField.textColor = DS.Colors.textPrimary
        textField.font = DS.Typography.body()
        textField.layer.cornerRadius = DS.CornerRadius.m
        textField.layer.borderWidth = 1
        textField.layer.borderColor = DS.Colors.border.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: DS.Spacing.m, height: 1))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: DS.Spacing.m, height: 1))
        textField.rightViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true

        errorLabel.apply(.error)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DS.Spacing.xs
    }

    private func setupHierarchy() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(errorLabel)

        addSubview(stackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

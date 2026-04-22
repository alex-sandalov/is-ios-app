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
    private var textField = UITextField()
    private var errorLabel = UILabel()
    private var stackView = UIStackView()

    var onTextChanged: ((String) -> Void)?

    var currentText: String {
        textField.text ?? ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
        errorLabel.isHidden = (config.errorMessage?.isEmpty ?? true)
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DS.Spacing.xs

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.apply(.captionSecondary)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = DS.Colors.surface
        textField.layer.cornerRadius = DS.CornerRadius.m
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.apply(.error)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
    }

    private func setupLayout() {
        addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(errorLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc
    private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }
}

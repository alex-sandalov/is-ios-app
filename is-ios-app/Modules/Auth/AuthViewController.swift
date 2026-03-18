import UIKit

final class AuthViewController: UIViewController, AuthView {
    var presenter: AuthPresenter!

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let brandLabel = UILabel()

    private let cardView = UIView()
    private let loginTextField = UITextField()
    private let passwordTextField = UITextField()
    private let errorLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupActions()
        setupKeyboardObservers()
        presenter.didLoad()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func render(_ state: AuthViewState) {
        switch state {
        case .idle:
            errorLabel.isHidden = true
            errorLabel.text = nil
            loginButton.isEnabled = true
            loginButton.alpha = 1
            activityIndicator.stopAnimating()

        case .loading:
            errorLabel.isHidden = true
            errorLabel.text = nil
            loginButton.isEnabled = false
            loginButton.alpha = 0.7
            activityIndicator.startAnimating()

        case .error(let message):
            errorLabel.isHidden = false
            errorLabel.text = message
            loginButton.isEnabled = true
            loginButton.alpha = 1
            activityIndicator.stopAnimating()

        case .authorized:
            errorLabel.isHidden = true
            errorLabel.text = nil
            loginButton.isEnabled = true
            loginButton.alpha = 1
            activityIndicator.stopAnimating()
        }
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Авторизация"

        scrollView.keyboardDismissMode = .interactive

        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.text = "Beta-Bank"
        brandLabel.font = .systemFont(ofSize: 34, weight: .heavy)
        brandLabel.textAlignment = .center
        brandLabel.textColor = .systemBlue

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cardView.layer.shadowRadius = 16

        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.borderStyle = .roundedRect
        loginTextField.placeholder = "Логин"
        loginTextField.keyboardType = .emailAddress
        loginTextField.autocapitalizationType = .none
        loginTextField.autocorrectionType = .no
        loginTextField.returnKeyType = .next
        loginTextField.delegate = self
        loginTextField.accessibilityIdentifier = "auth.loginTextField"

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        passwordTextField.delegate = self
        passwordTextField.accessibilityIdentifier = "auth.passwordTextField"

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 14
        loginButton.accessibilityIdentifier = "auth.loginButton"

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [brandLabel, cardView].forEach {
            contentView.addSubview($0)
        }

        [loginTextField, passwordTextField, errorLabel, loginButton, activityIndicator].forEach {
            cardView.addSubview($0)
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            brandLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            cardView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 40),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.topAnchor.constraint(greaterThanOrEqualTo: brandLabel.bottomAnchor, constant: 32),
            cardView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24),

            loginTextField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            loginTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            loginTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            loginTextField.heightAnchor.constraint(equalToConstant: 46),

            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 46),

            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            loginButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 52),

            activityIndicator.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            activityIndicator.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
        ])
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }

    @objc
    private func didTapLogin() {
        presenter.didTapLogin(
            login: loginTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc
    private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }

        let keyboardFrame = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardFrame)

        scrollView.contentInset.bottom = intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = intersection.height
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapLogin()
        }
        return true
    }
}

import UIKit

@MainActor
final class AuthViewController: UIViewController {
    var presenter: AuthPresenter?

    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var cardView = DSCardView()

    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var loginFieldView = DSTextFieldView()
    private var passwordFieldView = DSTextFieldView()
    private var loginButton = DSButton()
    private var stateView = DSStateView()
    private var contentStackView = UIStackView()

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DS.Colors.background
        title = "Авторизация"

        setupViews()
        setupHierarchy()
        setupLayout()

        presenter?.didLoad()
    }

    func render(config: AuthScreenConfig) {
        titleLabel.text = config.titleText
        subtitleLabel.text = config.subtitleText
        loginFieldView.configure(with: config.loginFieldConfig)
        passwordFieldView.configure(with: config.passwordFieldConfig)
        loginButton.configure(with: config.loginButtonConfig)
        stateView.configure(with: config.stateViewConfig)
    }

    private func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.apply(.largeTitle)

        subtitleLabel.apply(.bodySecondary)
        subtitleLabel.numberOfLines = 0

        loginFieldView.delegate = self
        passwordFieldView.delegate = self

        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = DS.Spacing.m
        contentStackView.alignment = .fill
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(cardView)
        cardView.addSubview(contentStackView)
        view.addSubview(stateView)

        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
        contentStackView.addArrangedSubview(loginFieldView)
        contentStackView.addArrangedSubview(passwordFieldView)
        contentStackView.addArrangedSubview(loginButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.xl),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.m),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.m),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.xl),

            contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DS.Spacing.l),
            contentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DS.Spacing.m),
            contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DS.Spacing.m),
            contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DS.Spacing.l),

            loginButton.heightAnchor.constraint(equalToConstant: 48),

            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }

    @objc
    private func didTapLogin() {
        presenter?.didTapLogin(
            login: loginFieldView.inputText,
            password: passwordFieldView.inputText
        )
    }
}

@MainActor
extension AuthViewController: AuthView {}

@MainActor
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === loginFieldView.textField {
            passwordFieldView.focus()
            return true
        }

        if textField === passwordFieldView.textField {
            didTapLogin()
            return true
        }

        return true
    }
}

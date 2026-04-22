import UIKit

@MainActor
final class AuthViewController: BDUIScreenHostingViewController, AuthView {
    var presenter: AuthPresenter?

    init() {
        let loader = BundleBDUIScreenLoader()
        let registry = BDUIMapperRegistry.makeDefault()
        let actionBinder = BDUIActionBinder()
        let actionHandler = BDUIActionHandler()

        super.init(
            loader: loader,
            registry: registry,
            actionBinder: actionBinder,
            actionHandler: actionHandler
        )
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = nil
        navigationItem.title = nil
        navigationItem.largeTitleDisplayMode = .never

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )

        onCallback = { [weak self] callbackId in
            guard let self else { return }

            switch callbackId {
            case "auth_login_tap":
                let login = (renderedView(withID: "auth_login_field") as? DSTextFieldView)?.currentText ?? ""
                let password = (renderedView(withID: "auth_password_field") as? DSTextFieldView)?.currentText ?? ""

                presenter?.didTapLogin(login: login, password: password)

            default:
                break
            }
        }

        presenter?.didLoad()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.didLoad()
    }

    func render(screen: AuthBDUIScreen) {
        render(
            templateName: screen.templateName,
            context: screen.context
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
        let bottomInset = max(0, intersection.height)

        guard let scrollRoot = renderedRootViewInstance() as? BDUIScrollContainerView else {
            return
        }

        scrollRoot.setKeyboardInset(bottomInset + 16)

        if bottomInset > 0,
           let loginButton = renderedView(withID: "auth_login_button") {
            scrollRoot.scrollToVisible(loginButton, animated: true)
        }
    }
}

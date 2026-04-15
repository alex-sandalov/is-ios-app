import UIKit

@MainActor
final class AuthPresenterImpl: AuthPresenter {
    private weak var view: AuthView?
    private let router: AuthRouter
    private let loginUseCase: LoginUseCase

    init(
        view: AuthView,
        router: AuthRouter,
        loginUseCase: LoginUseCase
    ) {
        self.view = view
        self.router = router
        self.loginUseCase = loginUseCase
    }

    func didLoad() {
        view?.render(config: makeIdleConfig())
    }

    func didTapLogin(login: String, password: String) {
        view?.render(config: makeLoadingConfig(login: login, password: password))

        Task { [weak self] in
            guard let self else { return }

            do {
                let request = LoginRequest(login: login, password: password)
                let session = try await loginUseCase.execute(request: request)

                view?.render(config: makeIdleConfig(login: login, password: password))
                router.openProductsList(session: session)
            } catch {
                view?.render(config: makeErrorConfig(
                    login: login,
                    password: password,
                    message: "Неверный логин или пароль"
                ))
            }
        }
    }

    private func makeIdleConfig(
        login: String? = nil,
        password: String? = nil
    ) -> AuthScreenConfig {
        AuthScreenConfig(
            titleText: "Beta Bank",
            subtitleText: "Войдите, чтобы увидеть список продуктов",
            loginFieldConfig: .init(
                title: "Логин",
                placeholder: "Введите логин",
                text: login,
                errorMessage: nil,
                isSecure: false,
                keyboardType: .emailAddress,
                textContentType: .username,
                returnKeyType: .next
            ),
            passwordFieldConfig: .init(
                title: "Пароль",
                placeholder: "Введите пароль",
                text: password,
                errorMessage: nil,
                isSecure: true,
                keyboardType: .default,
                textContentType: .password,
                returnKeyType: .done
            ),
            loginButtonConfig: .init(
                title: "Войти",
                style: .primary,
                isEnabled: true
            ),
            stateViewConfig: .init(
                style: .hidden,
                title: nil,
                message: nil,
                actionTitle: nil
            )
        )
    }

    private func makeLoadingConfig(login: String, password: String) -> AuthScreenConfig {
        AuthScreenConfig(
            titleText: "Beta Bank",
            subtitleText: "Войдите, чтобы увидеть список продуктов",
            loginFieldConfig: .init(
                title: "Логин",
                placeholder: "Введите логин",
                text: login,
                errorMessage: nil,
                isSecure: false,
                keyboardType: .emailAddress,
                textContentType: .username,
                returnKeyType: .next
            ),
            passwordFieldConfig: .init(
                title: "Пароль",
                placeholder: "Введите пароль",
                text: password,
                errorMessage: nil,
                isSecure: true,
                keyboardType: .default,
                textContentType: .password,
                returnKeyType: .done
            ),
            loginButtonConfig: .init(
                title: "Войти",
                style: .primary,
                isEnabled: false
            ),
            stateViewConfig: .init(
                style: .loading,
                title: "Входим",
                message: "Проверяем логин и пароль",
                actionTitle: nil
            )
        )
    }

    private func makeErrorConfig(
        login: String,
        password: String,
        message: String
    ) -> AuthScreenConfig {
        AuthScreenConfig(
            titleText: "Beta Bank",
            subtitleText: "Войдите, чтобы увидеть список продуктов",
            loginFieldConfig: .init(
                title: "Логин",
                placeholder: "Введите логин",
                text: login,
                errorMessage: nil,
                isSecure: false,
                keyboardType: .emailAddress,
                textContentType: .username,
                returnKeyType: .next
            ),
            passwordFieldConfig: .init(
                title: "Пароль",
                placeholder: "Введите пароль",
                text: password,
                errorMessage: message,
                isSecure: true,
                keyboardType: .default,
                textContentType: .password,
                returnKeyType: .done
            ),
            loginButtonConfig: .init(
                title: "Войти",
                style: .primary,
                isEnabled: true
            ),
            stateViewConfig: .init(
                style: .error,
                title: "Ошибка",
                message: message,
                actionTitle: nil
            )
        )
    }
}

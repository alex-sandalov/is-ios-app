import Foundation

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
        view?.render(screen: .idle)
    }

    func didTapLogin(login: String, password: String) {
        view?.render(screen: .loading)

        Task { [weak self] in
            guard let self else { return }

            do {
                let request = LoginRequest(login: login, password: password)
                let session = try await loginUseCase.execute(request: request)
                router.openProductsList(session: session)
            } catch {
                view?.render(screen: .error(message: "Неверный логин или пароль"))
            }
        }
    }
}

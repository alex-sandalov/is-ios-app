import Foundation

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
        view?.render(.idle)
    }

    func didTapLogin(login: String, password: String) {
        Task { @MainActor in
            view?.render(.loading)

            do {
                let request = LoginRequest(login: login, password: password)
                let session = try await loginUseCase.execute(request: request)
                view?.render(.authorized)
                router.openProductsList(session: session)
            } catch {
                let message = (error as? LocalizedError)?.errorDescription ?? "Произошла ошибка"
                view?.render(.error(message: message))
            }
        }
    }
}

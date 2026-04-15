import Foundation

@MainActor
protocol AuthView: AnyObject {
    func render(config: AuthScreenConfig)
}

@MainActor
protocol AuthPresenter: AnyObject {
    func didLoad()
    func didTapLogin(login: String, password: String)
}

@MainActor
protocol AuthRouter {
    func openProductsList(session: UserSession)
}

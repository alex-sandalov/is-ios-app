import Foundation

@MainActor
protocol AuthView: AnyObject {
    func render(screen: AuthBDUIScreen)
}

@MainActor
protocol AuthPresenter: AnyObject {
    func didLoad()
    func didTapLogin(login: String, password: String)
}

@MainActor
protocol AuthRouter: AnyObject {
    func openProductsList(session: UserSession)
}

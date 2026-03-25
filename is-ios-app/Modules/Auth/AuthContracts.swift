import Foundation

protocol AuthView: AnyObject {
    func render(_ state: AuthViewState)
}

protocol AuthPresenter {
    func didLoad()
    func didTapLogin(login: String, password: String)
}

protocol AuthRouter {
    func openProductsList(session: UserSession)
}

import UIKit

final class AuthRouterImpl: AuthRouter {
    weak var viewController: UIViewController?

    func openProductsList(session: UserSession) {
        let viewController = ProductsListStubViewController(session: session)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}

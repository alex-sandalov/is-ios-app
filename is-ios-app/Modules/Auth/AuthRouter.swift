import UIKit

final class AuthRouterImpl: AuthRouter {
    weak var viewController: UIViewController?

    private let productsListModuleFactory: ProductsListModuleBuilding

    init(productsListModuleFactory: ProductsListModuleBuilding) {
        self.productsListModuleFactory = productsListModuleFactory
    }

    @MainActor
    func openProductsList(session: UserSession) {
        let productsListViewController = productsListModuleFactory.makeModule(session: session)
        viewController?.navigationController?.pushViewController(productsListViewController, animated: true)
    }
}

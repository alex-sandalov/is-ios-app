import UIKit

protocol ProductsListModuleBuilding {
    @MainActor
    func makeModule(session: UserSession) -> UIViewController
}

final class ProductsListModuleFactory: ProductsListModuleBuilding {
    private let productsURL: URL

    init(productsURL: URL) {
        self.productsURL = productsURL
    }

    @MainActor
    func makeModule(session: UserSession) -> UIViewController {
        let viewController = ProductsListViewController()
        let router = ProductsListRouterImpl()

        let networkClient = URLSessionNetworkClient(urlSession: .shared)
        let requestFactory = ProductsRequestFactory(productsURL: productsURL)
        let domainMapper = ProductDomainMapper()
        let repository = RemoteProductsRepository(
            networkClient: networkClient,
            requestFactory: requestFactory,
            domainMapper: domainMapper
        )
        let loadProductsUseCase = LoadProductsUseCaseImpl(repository: repository)
        let stateMapper = ProductsListStateMapper()

        let presenter = ProductsListPresenterImpl(
            view: viewController,
            router: router,
            loadProductsUseCase: loadProductsUseCase,
            stateMapper: stateMapper,
            session: session
        )

        viewController.presenter = presenter
        router.viewController = viewController

        return viewController
    }
}

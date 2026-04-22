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

        let networkClient = URLSessionNetworkClient(urlSession: .shared)
        let requestFactory = ProductsRequestFactory(productsURL: productsURL)
        let domainMapper = ProductDomainMapper()
        let repository = RemoteProductsRepository(
            networkClient: networkClient,
            requestFactory: requestFactory,
            domainMapper: domainMapper
        )
        let loadProductsUseCase = LoadProductsUseCaseImpl(repository: repository)
        let screenFactory = ProductsListBDUIScreenFactory()

        let presenter = ProductsListPresenterImpl(
            view: viewController,
            loadProductsUseCase: loadProductsUseCase,
            screenFactory: screenFactory,
            session: session
        )

        viewController.presenter = presenter
        return viewController
    }
}

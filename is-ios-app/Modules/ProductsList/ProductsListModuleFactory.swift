import UIKit

protocol ProductsListModuleBuilding {
    @MainActor
    func makeModule(session: UserSession) -> UIViewController
}

final class ProductsListModuleFactory: ProductsListModuleBuilding {
    private let productsURL: URL
    private let remoteBDUIScreenModuleFactory: RemoteBDUIScreenModuleBuilding
    private let remoteBDUIEndpointFactory: RemoteBDUIEndpointFactory

    init(
        productsURL: URL,
        remoteBDUIScreenModuleFactory: RemoteBDUIScreenModuleBuilding,
        remoteBDUIEndpointFactory: RemoteBDUIEndpointFactory
    ) {
        self.productsURL = productsURL
        self.remoteBDUIScreenModuleFactory = remoteBDUIScreenModuleFactory
        self.remoteBDUIEndpointFactory = remoteBDUIEndpointFactory
    }

    @MainActor
    func makeModule(session: UserSession) -> UIViewController {
        let viewController = ProductsListViewController()

        let router = ProductsListRouterImpl(
            remoteBDUIScreenModuleFactory: remoteBDUIScreenModuleFactory,
            endpointFactory: remoteBDUIEndpointFactory
        )
        router.viewController = viewController

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
            router: router,
            loadProductsUseCase: loadProductsUseCase,
            screenFactory: screenFactory,
            session: session
        )

        viewController.presenter = presenter

        return viewController
    }
}

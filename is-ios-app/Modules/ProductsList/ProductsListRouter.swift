import UIKit

@MainActor
final class ProductsListRouterImpl: ProductsListRouter {
    weak var viewController: UIViewController?

    private let remoteBDUIScreenModuleFactory: RemoteBDUIScreenModuleBuilding
    private let endpointFactory: RemoteBDUIEndpointFactory

    init(
        remoteBDUIScreenModuleFactory: RemoteBDUIScreenModuleBuilding,
        endpointFactory: RemoteBDUIEndpointFactory
    ) {
        self.remoteBDUIScreenModuleFactory = remoteBDUIScreenModuleFactory
        self.endpointFactory = endpointFactory
    }

    func openRemoteBDUIScreen(_ screen: ProductsListRemoteBDUIScreen) {
        let endpoint = endpointFactory.makeEndpoint(key: screen.key)

        let config = RemoteBDUIScreenConfig(
            title: screen.title,
            endpoint: endpoint,
            retryTitle: "Повторить"
        )

        let controller = remoteBDUIScreenModuleFactory.makeModule(config: config)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}

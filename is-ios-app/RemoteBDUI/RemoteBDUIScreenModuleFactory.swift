import UIKit

protocol RemoteBDUIScreenModuleBuilding {
    @MainActor
    func makeModule(config: RemoteBDUIScreenConfig) -> UIViewController
}

final class RemoteBDUIScreenModuleFactory: RemoteBDUIScreenModuleBuilding {
    private let remoteLoader: RemoteBDUIScreenLoading
    private let stateFactory: RemoteBDUIScreenStateFactory

    init(
        remoteLoader: RemoteBDUIScreenLoading = RemoteBDUIScreenLoader(),
        stateFactory: RemoteBDUIScreenStateFactory = RemoteBDUIScreenStateFactory()
    ) {
        self.remoteLoader = remoteLoader
        self.stateFactory = stateFactory
    }

    @MainActor
    func makeModule(config: RemoteBDUIScreenConfig) -> UIViewController {
        RemoteBDUIScreenViewController(
            config: config,
            remoteLoader: remoteLoader,
            stateFactory: stateFactory
        )
    }
}

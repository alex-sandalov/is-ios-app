import UIKit

@MainActor
final class RemoteBDUIScreenViewController: BDUIScreenHostingViewController {
    private let config: RemoteBDUIScreenConfig
    private let remoteLoader: RemoteBDUIScreenLoading
    private let stateFactory: RemoteBDUIScreenStateFactory

    private var loadingTask: Task<Void, Never>?

    init(
        config: RemoteBDUIScreenConfig,
        remoteLoader: RemoteBDUIScreenLoading,
        stateFactory: RemoteBDUIScreenStateFactory
    ) {
        self.config = config
        self.remoteLoader = remoteLoader
        self.stateFactory = stateFactory

        super.init(
            loader: BundleBDUIScreenLoader(),
            registry: BDUIMapperRegistry.makeDefault(),
            actionBinder: BDUIActionBinder(),
            actionHandler: BDUIActionHandler()
        )
    }

    required init?(coder: NSCoder) {
        nil
    }

    deinit {
        loadingTask?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = config.title
        navigationItem.largeTitleDisplayMode = .never

        onCallback = { [weak self] callbackId in
            switch callbackId {
            case "remote_bdui_retry":
                self?.loadRemoteScreen()

            default:
                break
            }
        }

        loadRemoteScreen()
    }

    private func loadRemoteScreen() {
        loadingTask?.cancel()
        render(screen: stateFactory.makeLoadingScreen())

        let endpoint = config.endpoint
        let retryTitle = config.retryTitle
        let remoteLoader = remoteLoader
        let stateFactory = stateFactory

        loadingTask = Task { [weak self] in
            do {
                let screen = try await remoteLoader.loadScreen(from: endpoint)

                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self?.render(screen: screen)
                }
            } catch {
                guard !Task.isCancelled else { return }

                let errorScreen = stateFactory.makeErrorScreen(
                    message: error.localizedDescription,
                    retryTitle: retryTitle
                )

                await MainActor.run {
                    self?.render(screen: errorScreen)
                }
            }
        }
    }
}

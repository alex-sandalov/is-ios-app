import Foundation

@MainActor
protocol BDUIScreenReloading: AnyObject {
    func reloadScreen()
}

@MainActor
protocol BDUIScreenRouting: AnyObject {
    func route(destination: String, payload: String?)
}

@MainActor
protocol BDUIEventSink: AnyObject {
    func handleCallback(id: String)
}

@MainActor
protocol BDUIActionHandling: AnyObject {
    func handle(_ action: BDUIActionDTO)
}

@MainActor
final class BDUIActionHandler: BDUIActionHandling {
    weak var reloader: BDUIScreenReloading?
    weak var router: BDUIScreenRouting?
    weak var eventSink: BDUIEventSink?

    func handle(_ action: BDUIActionDTO) {
        switch action {
        case .callback(let id):
            eventSink?.handleCallback(id: id)

        case .reload:
            reloader?.reloadScreen()

        case .route(let destination, let payload):
            router?.route(destination: destination, payload: payload)
        }
    }
}

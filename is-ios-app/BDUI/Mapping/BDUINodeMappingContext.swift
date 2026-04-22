import UIKit

@MainActor
final class BDUINodeMappingContext {
    let registry: BDUIMapperRegistry
    let actionBinder: BDUIActionBinding
    weak var actionHandler: BDUIActionHandling?

    private(set) var renderedViewsByID: [String: UIView] = [:]

    init(
        registry: BDUIMapperRegistry,
        actionBinder: BDUIActionBinding,
        actionHandler: BDUIActionHandling
    ) {
        self.registry = registry
        self.actionBinder = actionBinder
        self.actionHandler = actionHandler
    }

    func register(
        view: UIView,
        for id: String
    ) {
        renderedViewsByID[id] = view
    }

    func view(for id: String) -> UIView? {
        renderedViewsByID[id]
    }

    func bindAction(
        _ action: BDUIActionDTO?,
        to view: UIView
    ) {
        guard let actionHandler else { return }
        actionBinder.bind(
            action: action,
            to: view,
            handler: actionHandler
        )
    }

    func mapChildren(_ nodes: [BDUINodeDTO]) -> [UIView] {
        nodes.compactMap { registry.map(node: $0, context: self) }
    }
}

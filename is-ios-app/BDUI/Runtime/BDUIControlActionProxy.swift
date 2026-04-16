import UIKit

@MainActor
final class BDUIControlActionProxy: NSObject {
    private let action: BDUIActionDTO
    private weak var handler: BDUIActionHandling?

    init(
        action: BDUIActionDTO,
        handler: BDUIActionHandling
    ) {
        self.action = action
        self.handler = handler
    }

    @objc
    func invoke() {
        handler?.handle(action)
    }
}

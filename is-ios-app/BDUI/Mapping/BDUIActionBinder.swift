import UIKit

@MainActor
protocol BDUIActionBinding: AnyObject {
    func bind(
        action: BDUIActionDTO?,
        to view: UIView,
        handler: BDUIActionHandling
    )
}

@MainActor
final class BDUIActionBinder: BDUIActionBinding {
    private var retainedProxies: [BDUIControlActionProxy] = []

    func bind(
        action: BDUIActionDTO?,
        to view: UIView,
        handler: BDUIActionHandling
    ) {
        guard let action else { return }

        if let button = view as? DSButton {
            let proxy = BDUIControlActionProxy(action: action, handler: handler)
            retainedProxies.append(proxy)
            button.addTarget(proxy, action: #selector(BDUIControlActionProxy.invoke), for: .touchUpInside)
            return
        }

        if let stateView = view as? DSStateView {
            stateView.onActionTap = { [weak handler] in
                handler?.handle(action)
            }
            return
        }

        if let textFieldView = view as? DSTextFieldView {
            textFieldView.onTextChanged = { [weak handler] _ in
                handler?.handle(action)
            }
        }
    }
}

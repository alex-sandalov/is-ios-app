import UIKit

@MainActor
class BDUIScreenHostingViewController: UIViewController, BDUIScreenReloading, BDUIEventSink {
    private let loader: BDUIScreenLoading
    private let registry: BDUIMapperRegistry
    private let actionBinder: BDUIActionBinding
    private let actionHandler: BDUIActionHandler
    
    private var currentTemplateName: String = ""
    private var currentContext: [String: String] = [:]
    private var renderedRootView = UIView()
    
    private var mappingContext: BDUINodeMappingContext?
    private var directScreen: BDUIScreenDTO?
    
    var onCallback: ((String) -> Void)?
    
    init(
        loader: BDUIScreenLoading,
        registry: BDUIMapperRegistry,
        actionBinder: BDUIActionBinding,
        actionHandler: BDUIActionHandler
    ) {
        self.loader = loader
        self.registry = registry
        self.actionBinder = actionBinder
        self.actionHandler = actionHandler
        super.init(nibName: nil, bundle: nil)
        
        self.actionHandler.reloader = self
        self.actionHandler.eventSink = self
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Colors.background
    }
    
    func render(
        templateName: String,
        context: [String: String]
    ) {
        directScreen = nil
        currentTemplateName = templateName
        currentContext = context
        reloadScreen()
    }
    
    func render(screen: BDUIScreenDTO) {
        directScreen = screen
        reloadScreen()
    }
    
    func reloadScreen() {
        renderedRootView.removeFromSuperview()
        
        do {
            let screen: BDUIScreenDTO
            
            if let directScreen {
                screen = directScreen
            } else {
                guard !currentTemplateName.isEmpty else { return }
                screen = try loader.loadScreen(
                    named: currentTemplateName,
                    context: currentContext
                )
            }
            
            let mappingContext = BDUINodeMappingContext(
                registry: registry,
                actionBinder: actionBinder,
                actionHandler: actionHandler
            )
            self.mappingContext = mappingContext
            
            let rootView = registry.map(node: screen.root, context: mappingContext) ?? UIView()
            
            rootView.translatesAutoresizingMaskIntoConstraints = false
            renderedRootView = rootView
            
            view.addSubview(rootView)
            
            NSLayoutConstraint.activate([
                rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                rootView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
            ])
        } catch {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.apply(.error)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.text = "BDUI error: \(error.localizedDescription)"
            renderedRootView = label
            
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.m),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.m)
            ])
        }
    }
    
    func handleCallback(id: String) {
        onCallback?(id)
    }
    
    func renderedView(withID id: String) -> UIView? {
        mappingContext?.view(for: id)
    }
        
    func renderedRootViewInstance() -> UIView {
        renderedRootView
    }
}

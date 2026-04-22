import UIKit

@MainActor
final class ProductsListViewController: UIViewController, ProductsListView {
    var presenter: ProductsListPresenter?

    private let loader = BundleBDUIScreenLoader()
    private let registry = BDUIMapperRegistry.makeDefault()
    private let actionBinder = BDUIActionBinder()
    private let actionHandler = BDUIActionHandler()

    private var rootStackView = UIStackView()
    private var headerStackView = UIStackView()
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var searchFieldView = DSTextFieldView()
    private var contentContainerView = UIView()
    private var renderedContentView = UIView()

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DS.Colors.background
        title = nil
        navigationItem.title = nil
        navigationItem.largeTitleDisplayMode = .never

        setupUI()
        setupLayout()
        setupBindings()

        presenter?.didLoad()
    }

    func renderLoading() {
        renderTemplate(
            name: "products_loading",
            context: [:]
        )
    }

    func renderScreen(_ screen: BDUIScreenDTO) {
        renderBDUIScreen(screen)
    }

    func renderError(message: String) {
        renderTemplate(
            name: "products_error",
            context: ["errorMessage": message]
        )
    }

    private func setupUI() {
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .vertical
        rootStackView.spacing = DS.Spacing.m

        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .vertical
        headerStackView.spacing = DS.Spacing.s

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.apply(.largeTitle)
        titleLabel.text = "Мои продукты"
        titleLabel.numberOfLines = 0

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.apply(.bodySecondary)
        subtitleLabel.text = "Карты, счета и вклады"
        subtitleLabel.numberOfLines = 0

        searchFieldView.translatesAutoresizingMaskIntoConstraints = false
        searchFieldView.configure(
            with: .init(
                title: "Поиск",
                placeholder: "Название, номер, тип, статус",
                text: nil,
                errorMessage: nil,
                isSecure: false,
                keyboardType: .default,
                textContentType: nil,
                returnKeyType: .default
            )
        )

        contentContainerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(rootStackView)
        rootStackView.addArrangedSubview(headerStackView)
        rootStackView.addArrangedSubview(contentContainerView)

        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(subtitleLabel)
        headerStackView.addArrangedSubview(searchFieldView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DS.Spacing.m),
            rootStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.m),
            rootStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.m),
            rootStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentContainerView.widthAnchor.constraint(equalTo: rootStackView.widthAnchor)
        ])
    }

    private func setupBindings() {
        actionHandler.reloader = nil
        actionHandler.eventSink = self

        searchFieldView.onTextChanged = { [weak self] text in
            self?.presenter?.didSearch(query: text)
        }
    }

    private func renderTemplate(
        name: String,
        context: [String: String]
    ) {
        do {
            let screen = try loader.loadScreen(named: name, context: context)
            renderBDUIScreen(screen)
        } catch {
            renderFallbackError("BDUI error: \(error.localizedDescription)")
        }
    }

    private func renderBDUIScreen(_ screen: BDUIScreenDTO) {
        renderedContentView.removeFromSuperview()

        let mappingContext = BDUINodeMappingContext(
            registry: registry,
            actionBinder: actionBinder,
            actionHandler: actionHandler
        )

        guard let contentView = registry.map(node: screen.root, context: mappingContext) else {
            renderFallbackError("Failed to render BDUI screen")
            return
        }

        contentView.translatesAutoresizingMaskIntoConstraints = false
        renderedContentView = contentView
        contentContainerView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])
    }

    private func renderFallbackError(_ message: String) {
        renderedContentView.removeFromSuperview()

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.error)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = message

        renderedContentView = label
        contentContainerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])
    }
}

extension ProductsListViewController: BDUIEventSink {
    func handleCallback(id: String) {
        switch id {
        case "products_retry_tap":
            presenter?.didTapRetry()
        default:
            break
        }
    }
}

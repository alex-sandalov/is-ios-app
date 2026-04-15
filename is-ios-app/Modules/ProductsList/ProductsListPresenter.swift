import Foundation

@MainActor
final class ProductsListPresenterImpl: ProductsListPresenter {
    private weak var view: ProductsListView?
    private let router: ProductsListRouter
    private let loadProductsUseCase: LoadProductsUseCase
    private let stateMapper: ProductsListStateMapping
    private let session: UserSession

    private var loadTask: Task<Void, Never>?
    private var allProducts: [BankProduct] = []
    private var visibleProducts: [BankProduct] = []
    private var currentQuery: String = ""

    init(
        view: ProductsListView,
        router: ProductsListRouter,
        loadProductsUseCase: LoadProductsUseCase,
        stateMapper: ProductsListStateMapping,
        session: UserSession
    ) {
        self.view = view
        self.router = router
        self.loadProductsUseCase = loadProductsUseCase
        self.stateMapper = stateMapper
        self.session = session
    }

    deinit {
        loadTask?.cancel()
    }

    func didLoad() {
        guard loadTask == nil, allProducts.isEmpty else { return }
        loadProducts(showLoadingState: true)
    }

    func didTapRetry() {
        loadProducts(showLoadingState: true)
    }

    func didPullToRefresh() {
        loadProducts(showLoadingState: false)
    }

    func didTapLogout() {
        loadTask?.cancel()
        router.openAuth()
    }

    func didSelectProduct(at index: Int) {
        guard visibleProducts.indices.contains(index) else { return }
        let product = visibleProducts[index]
        router.openProductDetails(productId: product.id, session: session)
    }

    func didChangeSearchText(_ text: String?) {
        currentQuery = (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        rebuildVisibleProductsAndRender()
    }

    private func loadProducts(showLoadingState: Bool) {
        loadTask?.cancel()

        if showLoadingState {
            view?.render(config: makeLoadingConfig())
        }

        loadTask = Task { [weak self] in
            guard let self else { return }

            defer { loadTask = nil }

            do {
                let products = try await loadProductsUseCase.execute(session: session)
                try Task.checkCancellation()

                allProducts = products
                rebuildVisibleProductsAndRender()
            } catch is CancellationError {
                return
            } catch {
                view?.render(config: makeErrorConfig(message: stateMapper.map(error: error)))
            }
        }
    }

    private func rebuildVisibleProductsAndRender() {
        if currentQuery.isEmpty {
            visibleProducts = allProducts
        } else {
            let loweredQuery = currentQuery.lowercased()
            visibleProducts = allProducts.filter { product in
                let subtitle = stateMapper.map(products: [product]).first?.subtitleText?.lowercased()
                let amount = stateMapper.map(products: [product]).first?.amountText.lowercased()
                let status = stateMapper.map(products: [product]).first?.statusText.lowercased()

                return product.title.lowercased().contains(loweredQuery)
                    || (subtitle?.contains(loweredQuery) ?? false)
                    || (amount?.contains(loweredQuery) ?? false)
                    || (status?.contains(loweredQuery) ?? false)
            }
        }

        if allProducts.isEmpty {
            view?.render(config: makeEmptyConfig(message: "Список продуктов пуст"))
            return
        }

        if !currentQuery.isEmpty && visibleProducts.isEmpty {
            view?.render(config: makeEmptyConfig(message: "Ничего не найдено"))
            return
        }

        let itemConfigs = stateMapper.map(products: visibleProducts)
        view?.render(config: makeContentConfig(items: itemConfigs))
    }

    private func makeBaseSearchConfig() -> DSSearchBarView.Config {
        .init(
            placeholder: "Поиск продуктов",
            text: currentQuery.isEmpty ? nil : currentQuery
        )
    }

    private func makeLoadingConfig() -> ProductsListScreenConfig {
        ProductsListScreenConfig(
            titleText: "Продукты",
            searchBarConfig: makeBaseSearchConfig(),
            stateViewConfig: .init(
                style: .loading,
                title: "Загрузка",
                message: "Получаем список продуктов",
                actionTitle: nil
            ),
            items: []
        )
    }

    private func makeErrorConfig(message: String) -> ProductsListScreenConfig {
        ProductsListScreenConfig(
            titleText: "Продукты",
            searchBarConfig: makeBaseSearchConfig(),
            stateViewConfig: .init(
                style: .error,
                title: "Ошибка",
                message: message,
                actionTitle: "Повторить"
            ),
            items: []
        )
    }

    private func makeEmptyConfig(message: String) -> ProductsListScreenConfig {
        ProductsListScreenConfig(
            titleText: "Продукты",
            searchBarConfig: makeBaseSearchConfig(),
            stateViewConfig: .init(
                style: .empty,
                title: "Пусто",
                message: message,
                actionTitle: nil
            ),
            items: []
        )
    }

    private func makeContentConfig(items: [ProductListCellConfig]) -> ProductsListScreenConfig {
        ProductsListScreenConfig(
            titleText: "Продукты",
            searchBarConfig: makeBaseSearchConfig(),
            stateViewConfig: .init(
                style: .hidden,
                title: nil,
                message: nil,
                actionTitle: nil
            ),
            items: items
        )
    }
}

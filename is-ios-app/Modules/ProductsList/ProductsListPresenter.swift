import Foundation

@MainActor
final class ProductsListPresenterImpl: ProductsListPresenter {
    private weak var view: ProductsListView?
    private let router: ProductsListRouter
    private let loadProductsUseCase: LoadProductsUseCase
    private let stateMapper: ProductsListStateMapping
    private let session: UserSession

    private var loadTask: Task<Void, Never>?
    private var allItems: [ProductListItem] = []
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
        guard loadTask == nil, allItems.isEmpty else { return }
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

    func didSelectProduct(id: String) {
        router.openProductDetails(productId: id, session: session)
    }

    func didChangeSearchQuery(_ query: String?) {
        let query = query ?? ""
        currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        renderFilteredItems()
    }

    private func loadProducts(showLoadingState: Bool) {
        loadTask?.cancel()

        if showLoadingState {
            view?.render(.loading)
        }

        loadTask = Task { [weak self] in
            guard let self else { return }

            defer { loadTask = nil }

            do {
                let products = try await loadProductsUseCase.execute(session: session)
                try Task.checkCancellation()

                let state = stateMapper.map(products: products)

                switch state {
                case .content(let items):
                    allItems = items
                    renderFilteredItems()
                case .empty:
                    allItems = []
                    view?.render(state)
                case .idle, .loading, .error:
                    view?.render(state)
                }
            } catch is CancellationError {
                return
            } catch {
                let message = stateMapper.map(error: error)
                view?.render(.error(message: message))
            }
        }
    }

    private func renderFilteredItems() {
        guard !allItems.isEmpty else {
            view?.render(.empty(message: "Список продуктов пуст"))
            return
        }

        guard !currentQuery.isEmpty else {
            view?.render(.content(allItems))
            return
        }

        let loweredQuery = currentQuery.lowercased()

        let filteredItems = allItems.filter { item in
            item.title.lowercased().contains(loweredQuery)
            || (item.subtitle?.lowercased().contains(loweredQuery) ?? false)
            || item.amountText.lowercased().contains(loweredQuery)
            || item.statusText.lowercased().contains(loweredQuery)
        }

        if filteredItems.isEmpty {
            view?.render(.empty(message: "Ничего не найдено"))
        } else {
            view?.render(.content(filteredItems))
        }
    }
}

import Foundation

@MainActor
final class ProductsListPresenterImpl: ProductsListPresenter {
    private weak var view: ProductsListView?
    private let router: ProductsListRouter
    private let loadProductsUseCase: LoadProductsUseCase
    private let stateMapper: ProductsListStateMapping
    private let session: UserSession

    private var loadTask: Task<Void, Never>?

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
        guard loadTask == nil else { return }
        loadProducts()
    }

    func didTapRetry() {
        loadProducts()
    }

    func didSelectProduct(id: String) {
        router.openProductDetails(productId: id, session: session)
    }

    func didTapLogout() {
        loadTask?.cancel()
        router.openAuth()
    }

    private func loadProducts() {
        loadTask?.cancel()
        view?.render(.loading)

        loadTask = Task { [weak self] in
            guard let self else { return }

            do {
                let products = try await loadProductsUseCase.execute(session: session)
                try Task.checkCancellation()

                let state = stateMapper.map(products: products)
                view?.render(state)
            } catch is CancellationError {
                return
            } catch {
                let message = stateMapper.map(error: error)
                view?.render(.error(message: message))
            }

            loadTask = nil
        }
    }
}

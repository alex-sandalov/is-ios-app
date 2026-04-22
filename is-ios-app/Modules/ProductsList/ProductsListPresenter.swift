import Foundation

@MainActor
final class ProductsListPresenterImpl: ProductsListPresenter {
    private weak var view: ProductsListView?
    private let loadProductsUseCase: LoadProductsUseCase
    private let screenFactory: ProductsListBDUIScreenFactory
    private let session: UserSession

    private var allProducts: [BankProduct] = []

    init(
        view: ProductsListView,
        loadProductsUseCase: LoadProductsUseCase,
        screenFactory: ProductsListBDUIScreenFactory,
        session: UserSession
    ) {
        self.view = view
        self.loadProductsUseCase = loadProductsUseCase
        self.screenFactory = screenFactory
        self.session = session
    }

    func didLoad() {
        loadProducts()
    }

    func didTapRetry() {
        loadProducts()
    }

    func didSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        let filtered: [BankProduct]
        if trimmed.isEmpty {
            filtered = allProducts
        } else {
            filtered = allProducts.filter { product in
                product.title.localizedCaseInsensitiveContains(trimmed)
                || (product.maskedNumber?.localizedCaseInsensitiveContains(trimmed) ?? false)
                || product.type.rawValue.localizedCaseInsensitiveContains(trimmed)
                || product.status.rawValue.localizedCaseInsensitiveContains(trimmed)
                || product.balance.currency.localizedCaseInsensitiveContains(trimmed)
            }
        }

        let screen = screenFactory.makeScreen(products: filtered)
        view?.renderScreen(screen)
    }

    private func loadProducts() {
        view?.renderLoading()

        Task { [weak self] in
            guard let self else { return }

            do {
                let products = try await loadProductsUseCase.execute(session: session)
                self.allProducts = products
                let screen = screenFactory.makeScreen(products: products)
                view?.renderScreen(screen)
            } catch {
                view?.renderError(message: "Не удалось загрузить продукты")
            }
        }
    }
}

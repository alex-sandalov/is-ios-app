import XCTest
@testable import is_ios_app

final class Lab4FlowTests: XCTestCase {

    func test_repository_fetchProducts_returnsMappedDomainModels() async throws {
        let networkClient = NetworkClientSpy()
        let requestFactory = ProductsRequestFactory(
            productsURL: URL(string: "https://alfaitmo.ru/echo/409515")!
        )

        networkClient.result = .success([
            ProductDTO(
                id: "card_001",
                type: "card",
                title: "Дебетовая карта",
                balance: ProductBalanceDTO(value: "45230.00", currency: "RUB"),
                maskedNumber: "**** **** **** 5678",
                status: "active"
            ),
            ProductDTO(
                id: "dep_001",
                type: "deposit",
                title: "Вклад Надежный",
                balance: ProductBalanceDTO(value: "1000000.00", currency: "RUB"),
                maskedNumber: nil,
                status: "blocked"
            )
        ])

        let sut = RemoteProductsRepository(
            networkClient: networkClient,
            requestFactory: requestFactory
        )

        let session = UserSession(token: "token", userId: "user_1")
        let products = try await sut.fetchProducts(session: session)

        XCTAssertEqual(products.count, 2)
        XCTAssertEqual(products[0].id, "card_001")
        XCTAssertEqual(products[0].type, .card)
        XCTAssertEqual(products[0].title, "Дебетовая карта")
        XCTAssertEqual(products[0].maskedNumber, "**** **** **** 5678")
        XCTAssertEqual(products[0].status, .active)
        XCTAssertEqual(products[0].balance.currency, "RUB")

        XCTAssertEqual(products[1].id, "dep_001")
        XCTAssertEqual(products[1].type, .deposit)
        XCTAssertEqual(products[1].status, .blocked)
        XCTAssertEqual(products[1].maskedNumber, nil)
    }

    func test_repository_fetchProducts_sendsExpectedGETRequest() async {
        let networkClient = NetworkClientSpy()
        let requestFactory = ProductsRequestFactory(
            productsURL: URL(string: "https://alfaitmo.ru/echo/409515")!
        )

        networkClient.result = .success([ProductDTO]())

        let sut = RemoteProductsRepository(
            networkClient: networkClient,
            requestFactory: requestFactory
        )

        let session = UserSession(token: "token", userId: "user_1")
        _ = try? await sut.fetchProducts(session: session)

        XCTAssertEqual(networkClient.sentRequests.count, 1)
        XCTAssertEqual(networkClient.sentRequests.first?.url?.absoluteString, "https://alfaitmo.ru/echo/409515")
        XCTAssertEqual(networkClient.sentRequests.first?.httpMethod, "GET")
        XCTAssertEqual(networkClient.sentRequests.first?.value(forHTTPHeaderField: "Accept"), "application/json")
    }

    func test_repository_fetchProducts_rethrowsNetworkError() async {
        let networkClient = NetworkClientSpy()
        let requestFactory = ProductsRequestFactory(
            productsURL: URL(string: "https://alfaitmo.ru/echo/409515")!
        )

        networkClient.result = .failure(NetworkError.transport)

        let sut = RemoteProductsRepository(
            networkClient: networkClient,
            requestFactory: requestFactory
        )

        let session = UserSession(token: "token", userId: "user_1")

        do {
            _ = try await sut.fetchProducts(session: session)
            XCTFail("Expected throw")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .transport)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_repository_fetchProducts_throwsDecodingError_whenDTOCannotBeMapped() async {
        let networkClient = NetworkClientSpy()
        let requestFactory = ProductsRequestFactory(
            productsURL: URL(string: "https://alfaitmo.ru/echo/409515")!
        )

        networkClient.result = .success([
            ProductDTO(
                id: "broken_001",
                type: "unknown_type",
                title: "Сломанный продукт",
                balance: ProductBalanceDTO(value: "10.00", currency: "RUB"),
                maskedNumber: nil,
                status: "active"
            )
        ])

        let sut = RemoteProductsRepository(
            networkClient: networkClient,
            requestFactory: requestFactory
        )

        let session = UserSession(token: "token", userId: "user_1")

        do {
            _ = try await sut.fetchProducts(session: session)
            XCTFail("Expected throw")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decoding)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - UseCase

    func test_useCase_execute_returnsProductsFromRepository() async throws {
        let repository = ProductsRepositorySpy()
        let expectedProducts = [
            BankProduct(
                id: "acc_001",
                type: .account,
                title: "Основной счет",
                balance: MoneyAmount(value: 125000.50, currency: "RUB"),
                maskedNumber: "40817****1234",
                status: .active
            )
        ]
        repository.fetchProductsResult = .success(expectedProducts)

        let sut = LoadProductsUseCaseImpl(repository: repository)
        let session = UserSession(token: "token", userId: "user_1")

        let products = try await sut.execute(session: session)

        XCTAssertEqual(products, expectedProducts)
        XCTAssertEqual(repository.fetchProductsCallCount, 1)
    }

    // MARK: - StateMapper

    func test_stateMapper_mapsProductsToContentState() {
        let sut = ProductsListStateMapper()
        let products = [
            BankProduct(
                id: "acc_001",
                type: .account,
                title: "Основной счет",
                balance: MoneyAmount(value: 125000.50, currency: "RUB"),
                maskedNumber: "40817****1234",
                status: .active
            )
        ]

        let state = sut.map(products: products)

        guard case .content(let items) = state else {
            XCTFail("Expected content state")
            return
        }

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].id, "acc_001")
        XCTAssertEqual(items[0].title, "Основной счет")
        XCTAssertEqual(items[0].subtitle, "Счёт • 40817****1234")
        XCTAssertEqual(items[0].statusText, "Активен")
    }

    func test_stateMapper_mapsEmptyProductsToEmptyState() {
        let sut = ProductsListStateMapper()
        let state = sut.map(products: [])
        XCTAssertEqual(state, .empty(message: "Список продуктов пуст"))
    }

    func test_stateMapper_mapsTransportErrorToReadableMessage() {
        let sut = ProductsListStateMapper()
        let message = sut.map(error: NetworkError.transport)
        XCTAssertEqual(message, "Не удалось загрузить данные. Проверьте интернет-соединение")
    }

    func test_stateMapper_mapsHTTPStatusErrorToReadableMessage() {
        let sut = ProductsListStateMapper()
        let message = sut.map(error: NetworkError.httpStatus(500))
        XCTAssertEqual(message, "Сервер вернул ошибку (500)")
    }

    // MARK: - Presenter

    @MainActor
    func test_presenter_didLoad_rendersLoadingThenContent() async {
        let view = ProductsListViewSpy()
        let router = ProductsListRouterSpy()
        let useCase = LoadProductsUseCaseSpy()
        let mapper = ProductsListStateMapper()

        useCase.result = .success([
            BankProduct(
                id: "acc_001",
                type: .account,
                title: "Основной счет",
                balance: MoneyAmount(value: 125000.50, currency: "RUB"),
                maskedNumber: "40817****1234",
                status: .active
            )
        ])

        let sut = ProductsListPresenterImpl(
            view: view,
            router: router,
            loadProductsUseCase: useCase,
            stateMapper: mapper,
            session: UserSession(token: "token", userId: "user_1")
        )

        sut.didLoad()
        await Task.yield()

        XCTAssertGreaterThanOrEqual(view.renderedStates.count, 2)
        XCTAssertEqual(view.renderedStates.first, .loading)

        guard case .content(let items) = view.renderedStates.last else {
            XCTFail("Expected content state")
            return
        }

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].id, "acc_001")
    }

    @MainActor
    func test_presenter_didLoad_rendersLoadingThenError() async {
        let view = ProductsListViewSpy()
        let router = ProductsListRouterSpy()
        let useCase = LoadProductsUseCaseSpy()
        let mapper = ProductsListStateMapper()

        useCase.result = .failure(NetworkError.transport)

        let sut = ProductsListPresenterImpl(
            view: view,
            router: router,
            loadProductsUseCase: useCase,
            stateMapper: mapper,
            session: UserSession(token: "token", userId: "user_1")
        )

        sut.didLoad()
        await Task.yield()

        XCTAssertGreaterThanOrEqual(view.renderedStates.count, 2)
        XCTAssertEqual(view.renderedStates.first, .loading)
        XCTAssertEqual(
            view.renderedStates.last,
            .error(message: "Не удалось загрузить данные. Проверьте интернет-соединение")
        )
    }

    @MainActor
    func test_presenter_didTapRetry_startsNewLoadingFlow() async {
        let view = ProductsListViewSpy()
        let router = ProductsListRouterSpy()
        let useCase = LoadProductsUseCaseSpy()
        let mapper = ProductsListStateMapper()

        useCase.result = .success([])

        let sut = ProductsListPresenterImpl(
            view: view,
            router: router,
            loadProductsUseCase: useCase,
            stateMapper: mapper,
            session: UserSession(token: "token", userId: "user_1")
        )

        sut.didTapRetry()
        await Task.yield()

        XCTAssertEqual(view.renderedStates.first, .loading)
        XCTAssertEqual(view.renderedStates.last, .empty(message: "Список продуктов пуст"))
        XCTAssertEqual(useCase.executeCallCount, 1)
    }

    @MainActor
    func test_presenter_didSelectProduct_routesToDetails() {
        let view = ProductsListViewSpy()
        let router = ProductsListRouterSpy()
        let useCase = LoadProductsUseCaseSpy()
        let mapper = ProductsListStateMapper()
        let session = UserSession(token: "token", userId: "user_1")

        let sut = ProductsListPresenterImpl(
            view: view,
            router: router,
            loadProductsUseCase: useCase,
            stateMapper: mapper,
            session: session
        )

        sut.didSelectProduct(id: "product_42")

        XCTAssertEqual(router.openedProductId, "product_42")
        XCTAssertEqual(router.openedSession, session)
    }

    @MainActor
    func test_presenter_didTapLogout_routesToAuth() {
        let view = ProductsListViewSpy()
        let router = ProductsListRouterSpy()
        let useCase = LoadProductsUseCaseSpy()
        let mapper = ProductsListStateMapper()

        let sut = ProductsListPresenterImpl(
            view: view,
            router: router,
            loadProductsUseCase: useCase,
            stateMapper: mapper,
            session: UserSession(token: "token", userId: "user_1")
        )

        sut.didTapLogout()

        XCTAssertEqual(router.openAuthCallCount, 1)
    }
}

// MARK: - Test Doubles

private final class NetworkClientSpy: NetworkClient {
    private(set) var sentRequests: [URLRequest] = []
    var result: Result<Any, Error> = .failure(NetworkError.transport)

    func send<Response: Decodable>(
        _ request: URLRequest,
        decoder: JSONDecoder
    ) async throws -> Response {
        sentRequests.append(request)

        switch result {
        case .success(let value):
            guard let typedValue = value as? Response else {
                throw NetworkError.decoding
            }
            return typedValue
        case .failure(let error):
            throw error
        }
    }
}

private final class ProductsRepositorySpy: ProductsRepository {
    var fetchProductsCallCount = 0
    var fetchProductsResult: Result<[BankProduct], Error> = .success([])

    func fetchProducts(session: UserSession) async throws -> [BankProduct] {
        fetchProductsCallCount += 1
        return try fetchProductsResult.get()
    }

    func fetchProductDetails(productId: String, session: UserSession) async throws -> ProductDetails {
        throw DomainError.notFound
    }
}

@MainActor
private final class ProductsListViewSpy: ProductsListView {
    private(set) var renderedStates: [ProductsListViewState] = []

    func render(_ state: ProductsListViewState) {
        renderedStates.append(state)
    }
}

private final class ProductsListRouterSpy: ProductsListRouter {
    private(set) var openedProductId: String?
    private(set) var openedSession: UserSession?
    private(set) var openAuthCallCount = 0

    func openProductDetails(productId: String, session: UserSession) {
        openedProductId = productId
        openedSession = session
    }

    func openAuth() {
        openAuthCallCount += 1
    }
}

private final class LoadProductsUseCaseSpy: LoadProductsUseCase {
    var executeCallCount = 0
    var result: Result<[BankProduct], Error> = .success([])

    func execute(session: UserSession) async throws -> [BankProduct] {
        executeCallCount += 1
        return try result.get()
    }
}

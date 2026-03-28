import Foundation

final class RemoteProductsRepository: ProductsRepository {
    private let networkClient: NetworkClient
    private let requestFactory: ProductsRequestFactory

    init(
        networkClient: NetworkClient,
        requestFactory: ProductsRequestFactory
    ) {
        self.networkClient = networkClient
        self.requestFactory = requestFactory
    }

    func fetchProducts(session: UserSession) async throws -> [BankProduct] {
        let request = requestFactory.makeProductsListRequest()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        let productDTOs: [ProductDTO] = try await networkClient.send(request, decoder: decoder)
        return try productDTOs.map { try $0.toDomain() }
    }

    func fetchProductDetails(productId: String, session: UserSession) async throws -> ProductDetails {
        throw DomainError.notFound
    }
}

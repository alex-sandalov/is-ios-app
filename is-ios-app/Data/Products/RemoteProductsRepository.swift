import Foundation

final class RemoteProductsRepository: ProductsRepository {
    private let networkClient: NetworkClient
    private let requestFactory: ProductsRequestFactory
    private let domainMapper: ProductDomainMapper

    init(
        networkClient: NetworkClient,
        requestFactory: ProductsRequestFactory,
        domainMapper: ProductDomainMapper
    ) {
        self.networkClient = networkClient
        self.requestFactory = requestFactory
        self.domainMapper = domainMapper
    }

    func fetchProducts(session: UserSession) async throws -> [BankProduct] {
        let request = requestFactory.makeProductsListRequest()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        let productDTOs: [ProductDTO] = try await networkClient.send(request, decoder: decoder)
        return try productDTOs.map { try domainMapper.map($0) }
    }

    func fetchProductDetails(productId: String, session: UserSession) async throws -> ProductDetails {
        throw DomainError.notFound
    }
}

import Foundation

final class LoadProductsUseCaseImpl: LoadProductsUseCase {
    private let repository: ProductsRepository

    init(repository: ProductsRepository) {
        self.repository = repository
    }

    func execute(session: UserSession) async throws -> [BankProduct] {
        try await repository.fetchProducts(session: session)
    }
}

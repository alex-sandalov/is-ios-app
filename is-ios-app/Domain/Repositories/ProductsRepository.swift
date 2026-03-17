import Foundation

protocol ProductsRepository {
    func fetchProducts(session: UserSession) async throws -> [BankProduct]
    func fetchProductDetails(productId: String, session: UserSession) async throws -> ProductDetails
}

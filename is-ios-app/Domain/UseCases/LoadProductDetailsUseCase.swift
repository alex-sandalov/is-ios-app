import Foundation

protocol LoadProductDetailsUseCase {
    func execute(productId: String, session: UserSession) async throws -> ProductDetails
}

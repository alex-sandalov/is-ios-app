import Foundation

protocol LoadProductsUseCase {
    func execute(session: UserSession) async throws -> [BankProduct]
}

import Foundation

protocol AuthRepository {
    func login(login: String, password: String) async throws -> UserSession
}

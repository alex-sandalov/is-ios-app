import Foundation

struct LoginRequest: Equatable {
    let login: String
    let password: String
}

protocol LoginUseCase {
    func execute(request: LoginRequest) async throws -> UserSession
}

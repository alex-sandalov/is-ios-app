import Foundation

enum AuthError: LocalizedError {
    case emptyFields
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Заполните логин и пароль"
        case .invalidCredentials:
            return "Неверный логин или пароль"
        }
    }
}

final class LocalLoginUseCase: LoginUseCase {
    private let validLogin = "itmo@itmo.itmo"
    private let validPassword = "itmoiscrazy"

    func execute(request: LoginRequest) async throws -> UserSession {
        let login = request.login.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = request.password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !login.isEmpty, !password.isEmpty else {
            throw AuthError.emptyFields
        }

        guard login == validLogin, password == validPassword else {
            throw AuthError.invalidCredentials
        }

        return UserSession(token: "local-token", userId: "1")
    }
}

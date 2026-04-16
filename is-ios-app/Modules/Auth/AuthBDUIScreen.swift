import Foundation

enum AuthBDUIScreen {
    case idle
    case loading
    case error(message: String)

    var templateName: String {
        switch self {
        case .idle:
            return "auth_idle"
        case .loading:
            return "auth_loading"
        case .error:
            return "auth_error"
        }
    }

    var context: [String: String] {
        switch self {
        case .idle:
            return [:]
        case .loading:
            return [:]
        case .error(let message):
            return [
                "errorMessage": message
            ]
        }
    }
}

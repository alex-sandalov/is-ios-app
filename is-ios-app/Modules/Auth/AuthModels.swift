import Foundation

struct AuthModuleInput: Equatable {
    let prefilledLogin: String?
}

enum AuthModuleOutput: Equatable {
    case didAuthorize(UserSession)
}

enum AuthViewState: Equatable {
    case idle
    case loading
    case error(message: String)
    case authorized
}

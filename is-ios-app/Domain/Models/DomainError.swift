import Foundation

enum DomainError: Error, Equatable {
    case invalidCredentials
    case validationFailed(message: String)
    case networkError
    case notFound
    case unknown
}

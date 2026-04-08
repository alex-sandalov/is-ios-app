import Foundation

enum NetworkError: Error, Equatable {
    case transport
    case httpStatus(Int)
    case invalidResponse
    case decoding
    case cancelled
}

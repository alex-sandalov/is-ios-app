import Foundation

protocol NetworkClient {
    func send<Response: Decodable>(
        _ request: URLRequest,
        decoder: JSONDecoder
    ) async throws -> Response
}

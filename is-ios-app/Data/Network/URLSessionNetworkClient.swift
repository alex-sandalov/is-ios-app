import Foundation

final class URLSessionNetworkClient: NetworkClient {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func send<Response: Decodable>(
        _ request: URLRequest,
        decoder: JSONDecoder
    ) async throws -> Response {
        do {
            let (data, response) = try await urlSession.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.httpStatus(httpResponse.statusCode)
            }

            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw NetworkError.decoding
            }
        } catch is CancellationError {
            throw NetworkError.cancelled
        } catch let urlError as URLError where urlError.code == .cancelled {
            throw NetworkError.cancelled
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.transport
        }
    }
}

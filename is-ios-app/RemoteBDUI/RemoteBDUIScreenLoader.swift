import Foundation

final class RemoteBDUIScreenLoader: RemoteBDUIScreenLoading {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func loadScreen(from endpoint: URL) async throws -> BDUIScreenDTO {
        let (data, response) = try await urlSession.data(from: endpoint)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RemoteBDUIScreenLoaderError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw RemoteBDUIScreenLoaderError.badStatusCode(httpResponse.statusCode)
        }

        return try decodeScreen(from: data)
    }

    private func decodeScreen(from data: Data) throws -> BDUIScreenDTO {
        let decoder = JSONDecoder()

        if let screen = try? decoder.decode(BDUIScreenDTO.self, from: data) {
            return screen
        }

        if let envelope = try? decoder.decode(RemoteBDUIScreenEnvelope.self, from: data) {
            if let screen = envelope.screen {
                return screen
            }

            if let data = envelope.data {
                return data
            }

            if let value = envelope.value {
                return value
            }

            if let rawScreen = envelope.rawScreen,
               let nestedData = rawScreen.data(using: .utf8),
               let nestedScreen = try? decoder.decode(BDUIScreenDTO.self, from: nestedData) {
                return nestedScreen
            }

            if let rawData = envelope.rawData,
               let nestedData = rawData.data(using: .utf8),
               let nestedScreen = try? decoder.decode(BDUIScreenDTO.self, from: nestedData) {
                return nestedScreen
            }

            if let rawValue = envelope.rawValue,
               let nestedData = rawValue.data(using: .utf8),
               let nestedScreen = try? decoder.decode(BDUIScreenDTO.self, from: nestedData) {
                return nestedScreen
            }
        }

        throw RemoteBDUIScreenLoaderError.decodingFailed
    }
}

private struct RemoteBDUIScreenEnvelope: Decodable {
    let screen: BDUIScreenDTO?
    let data: BDUIScreenDTO?
    let value: BDUIScreenDTO?

    let rawScreen: String?
    let rawData: String?
    let rawValue: String?

    private enum CodingKeys: String, CodingKey {
        case screen
        case data
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        screen = try? container.decode(BDUIScreenDTO.self, forKey: .screen)
        data = try? container.decode(BDUIScreenDTO.self, forKey: .data)
        value = try? container.decode(BDUIScreenDTO.self, forKey: .value)

        rawScreen = try? container.decode(String.self, forKey: .screen)
        rawData = try? container.decode(String.self, forKey: .data)
        rawValue = try? container.decode(String.self, forKey: .value)
    }
}

enum RemoteBDUIScreenLoaderError: LocalizedError {
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Некорректный ответ сервера"

        case .badStatusCode(let code):
            return "Сервер вернул ошибку: \(code)"

        case .decodingFailed:
            return "Не удалось распарсить BDUI-модель"
        }
    }
}

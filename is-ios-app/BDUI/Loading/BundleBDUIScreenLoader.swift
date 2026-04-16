import Foundation

@MainActor
protocol BDUIScreenLoading {
    func loadScreen(
        named name: String,
        context: [String: String]
    ) throws -> BDUIScreenDTO
}

@MainActor
final class BundleBDUIScreenLoader: BDUIScreenLoading {
    private let decoder = JSONDecoder()
    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func loadScreen(
        named name: String,
        context: [String: String]
    ) throws -> BDUIScreenDTO {
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw NSError(
                domain: "BDUI",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "JSON \(name).json not found"]
            )
        }

        let rawData = try Data(contentsOf: url)

        guard var rawString = String(data: rawData, encoding: .utf8) else {
            throw NSError(
                domain: "BDUI",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Invalid UTF-8 in \(name).json"]
            )
        }

        context.forEach { key, value in
            rawString = rawString.replacingOccurrences(of: "{{\(key)}}", with: value)
        }

        guard let finalData = rawString.data(using: .utf8) else {
            throw NSError(
                domain: "BDUI",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Failed to encode substituted JSON"]
            )
        }

        return try decoder.decode(BDUIScreenDTO.self, from: finalData)
    }
}

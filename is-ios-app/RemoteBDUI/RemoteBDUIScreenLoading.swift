import Foundation

protocol RemoteBDUIScreenLoading {
    func loadScreen(from endpoint: URL) async throws -> BDUIScreenDTO
}

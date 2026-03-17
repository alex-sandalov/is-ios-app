import Foundation

protocol SessionRepository {
    func save(session: UserSession) async throws
    func loadSession() async throws -> UserSession?
    func clearSession() async throws
}

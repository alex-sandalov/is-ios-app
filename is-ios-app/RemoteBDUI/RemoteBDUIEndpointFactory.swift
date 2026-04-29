import Foundation

struct RemoteBDUIEndpointFactory {
    private let baseURL: URL
    private let namespace: String

    init(
        baseURL: URL,
        namespace: String = "beta-bank"
    ) {
        self.baseURL = baseURL
        self.namespace = namespace
    }

    func makeEndpoint(key: String) -> URL {
        let echoPath = "\(namespace)/\(key)"

        let encodedEchoPath = echoPath.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlPathAllowed.subtracting(
                CharacterSet(charactersIn: "/")
            )
        ) ?? echoPath

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)

        let basePath = components?.percentEncodedPath.trimmingCharacters(in: CharacterSet(charactersIn: "/")) ?? ""
        components?.percentEncodedPath = "/" + basePath + "/" + encodedEchoPath

        guard let url = components?.url else {
            return baseURL
        }

        return url
    }
}

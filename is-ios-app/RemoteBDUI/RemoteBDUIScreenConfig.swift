import Foundation

struct RemoteBDUIScreenConfig {
    let title: String?
    let endpoint: URL
    let retryTitle: String

    init(
        title: String? = nil,
        endpoint: URL,
        retryTitle: String = "Повторить"
    ) {
        self.title = title
        self.endpoint = endpoint
        self.retryTitle = retryTitle
    }
}

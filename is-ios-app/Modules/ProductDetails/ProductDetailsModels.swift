import Foundation

struct ProductDetailsModuleInput: Equatable {
    let productId: String
    let session: UserSession
}

enum ProductDetailsModuleOutput: Equatable {
    case didClose
}

enum ProductDetailsViewState: Equatable {
    case idle
    case loading
    case content(ProductDetails)
    case error(message: String)
}

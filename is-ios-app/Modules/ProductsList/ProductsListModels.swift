import Foundation

struct ProductsListModuleInput: Equatable {
    let session: UserSession
}

enum ProductsListModuleOutput: Equatable {
    case didSelectProduct(id: String)
    case didRequestLogout
}

struct ProductListItem: Equatable {
    let id: String
    let title: String
    let subtitle: String?
    let amountText: String
    let statusText: String
}

enum ProductsListViewState: Equatable {
    case idle
    case loading
    case content([ProductListItem])
    case empty(message: String)
    case error(message: String)
}

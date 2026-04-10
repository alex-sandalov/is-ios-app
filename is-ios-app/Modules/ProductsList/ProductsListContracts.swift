import Foundation

@MainActor
protocol ProductsListView: AnyObject {
    func render(_ state: ProductsListViewState)
}

@MainActor
protocol ProductsListPresenter {
    func didLoad()
    func didTapRetry()
    func didTapLogout()
    func didSelectProduct(id: String)
    func didChangeSearchQuery(_ query: String?)
    func didPullToRefresh()
}

@MainActor
protocol ProductsListRouter {
    func openProductDetails(productId: String, session: UserSession)
    func openAuth()
}

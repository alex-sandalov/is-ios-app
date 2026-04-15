import Foundation

@MainActor
protocol ProductsListView: AnyObject {
    func render(config: ProductsListScreenConfig)
}

@MainActor
protocol ProductsListPresenter: AnyObject {
    func didLoad()
    func didTapRetry()
    func didTapLogout()
    func didSelectProduct(at index: Int)
    func didChangeSearchText(_ text: String?)
    func didPullToRefresh()
}

@MainActor
protocol ProductsListRouter {
    func openProductDetails(productId: String, session: UserSession)
    func openAuth()
}

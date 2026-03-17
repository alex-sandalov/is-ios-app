import Foundation

protocol ProductsListView: AnyObject {
    func render(_ state: ProductsListViewState)
}

protocol ProductsListPresenter {
    func didLoad()
    func didSelectProduct(id: String)
    func didTapLogout()
}

protocol ProductsListRouter {
    func openProductDetails(productId: String, session: UserSession)
    func openAuth()
}

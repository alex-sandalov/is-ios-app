import Foundation

@MainActor
protocol ProductsListView: AnyObject {
    func renderLoading()
    func renderScreen(_ screen: BDUIScreenDTO)
    func renderError(message: String)
}

@MainActor
protocol ProductsListPresenter: AnyObject {
    func didLoad()
    func didTapRetry()
    func didSearch(query: String)
}
